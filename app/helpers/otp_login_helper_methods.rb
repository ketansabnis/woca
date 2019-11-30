module OtpLoginHelperMethods
  include ApplicationHelper
  def self.included base
    base.extend ClassMethods
    base.include InstanceMethods

    base.field :last_otp_sent_at, type: Time
    base.field :resend_otp_counter, type: Integer
  end

  module ClassMethods
    def otp_resend_max_limit
      @@otp_resend_max_limit ||= 4
    end

    def otp_resend_wait_time
      @@otp_resend_wait_time ||= 15
    end

    def otp_locked_time
      @@otp_locked_time ||= 1800
    end
  end

  module InstanceMethods

    def send_otp
      self.reset_lock_status

      otp_sent_status = self.can_send_otp?

      if otp_sent_status[:status] && app_configuration.sms_enabled?
        Sms.create!(
          recipient_id: self.id,
          sms_template_id: Template::SmsTemplate.find_by(name: "otp").id,
          triggered_by_id: self.id,
          triggered_by_type: self.class.to_s
        )
        self.set({last_otp_sent_at: Time.now, resend_otp_counter: (self.resend_otp_counter.present? ? self.resend_otp_counter : 0 )+ 1})
      end
      otp_sent_status
    end

    def reset_lock_status
      if self.otp_limit_crossed? && self.last_otp_sent_at.present?
        if (self.last_otp_sent_at + self.class.otp_locked_time.seconds) <= Time.now
          self.reset_otp_counters
        end
      end
    end

    def otp_limit_crossed?
      self.resend_otp_counter.present? && self.resend_otp_counter >= self.class.otp_resend_max_limit
    end

    def check_otp_duration
      self.last_otp_sent_at.present? && (Time.now.to_i - self.last_otp_sent_at.to_i) < self.class.otp_resend_wait_time
    end

    def can_send_otp?
      valid = true
      error_message = ""

      if self.otp_limit_crossed?
        valid = false
        error_message = "Maximum limit reached to get OTP code. Please try again after #{(self.last_otp_sent_at + self.class.otp_locked_time.seconds).in_time_zone(self.time_zone).strftime("%d/%m/%Y %l:%M %p")}"

      end

      if self.check_otp_duration
        valid = false
        error_message = "Please wait for #{self.class.otp_resend_wait_time} seconds to resend OTP."
      end
      {status: valid, error: error_message}
    end

    def reset_otp_counters
      self.set({
        last_otp_sent_at: nil,
        resend_otp_counter: nil,
      })
    end

    def authenticate_otp (code, options = {})
      result = super
      if result
        self.reset_otp_counters
      end
      result
    end
  end
end
