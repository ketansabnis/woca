module PaymentGatewayService
  class Razorpay < Default
    def gateway_url(search_id)
      return "/dashboard/user/searches/#{search_id}/gateway-payment/#{@order.order_id}"
    end

    def response_handler! params
      begin
        response = ::Razorpay::Payment.fetch(params[:payment_id]).capture({
          amount: @order.total_amount.to_i * 100
        })
        @order.payment_identifier = params[:payment_id]
        @order.tracking_id = params[:payment_id]
        if response.status == 'captured'
          @order.status = "success"
          @order.status_message = "success"
        else
          @order.status = "failed"
          @order.status_message = "Some unknown error"
        end
      rescue => e
        @order.status = "failed"
        @order.status_message = e.to_s
      end
      @order.save
    end
  end
end
