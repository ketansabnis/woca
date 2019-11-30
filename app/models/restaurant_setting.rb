class RestaurantSetting
    include Mongoid::Document
    include Mongoid::Timestamps
    include ArrayBlankRejectable

    field :delivery_enabled, type: Boolean, default: false
    field :pick_up_enabled, type: Boolean, default: false
    field :delivery_time_in_minutes, type: Integer, default: 15
    field :pick_up_time_in_minutes, type: Integer, default: 15
    field :last_order_time_in_minutes, type: Integer, default: 30
    field :accept_future_orders, type: Boolean
    field :future_delivery_orders_in_days, type: Integer, default: 5
    field :future_pick_up_orders_in_days, type: Integer, default: 5
    field :accepted_payment_methods, type: Array, default: ['cod']

    belongs_to :restaurant
    
    validates :delivery_time_in_minutes, :pick_up_time_in_minutes, :last_order_time_in_minutes, :future_delivery_orders_in_days, :future_pick_up_orders_in_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def self.available_payment_methods
        [
            {id: "cod", text: "Cash on Delivery", default: true}
        ]
    end
    validates :accepted_payment_methods, array: { inclusion: {allow_blank: false, in:  RestaurantSetting.available_payment_methods.collect{|x| x[:id]}} }
end