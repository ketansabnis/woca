module PaymentGatewayService
  class Default
    def initialize(order)
      @order = order
    end

    def build_parameters
      {}
    end

    def gateway_url
      {}
    end

    def response_handler!
      nil
    end

    def self.allowed_payment_gateways
      ['CCAvenue', "Razorpay"]
    end
  end
end

if Rails.env.development?
  Dir["#{Rails.root}/app/services/payment_gateway_service/**/*.rb"].each do |f|
    file = f.gsub("#{Rails.root}/", "")
    load file
  end
end
