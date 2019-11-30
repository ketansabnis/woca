require 'net/http'
require 'rexml/document'
module Communication
  module Sms
    class SmsjustWorker
      include Sidekiq::Worker

      def perform sms_id
        sms = ::Sms.find sms_id
        params = {}
        params[:senderid] = app_configuration.sms_mask
        params[:dest_mobileno] = sms.to.join(",")
        params[:message] = sms.body
        params[:username] = app_configuration.sms_provider_username
        params[:pass] = app_configuration.sms_provider_password
        params[:response] = "Y"

        uri = URI("http://www.smsjust.com/blank/sms/user/urlsms.php")
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.get_response(uri).body

        if response.starts_with?("ES")
          sms.set(status: "fail")
          return {status:"fail", remote_id: response}
        else
          sms.set(status: "sent")
          return {status:"success", remote_id: response}
        end
      end
    end
  end
end
