class RestaurantOpenHours
    include Mongoid::Document
    include Mongoid::Timestamps
    include ArrayBlankRejectable

    field :day, type: Integer
    field :opening_hour, type: Integer, default: 0
    field :opening_minute, type: Integer, default: 0
    field :closing_hour, type: Integer, default: 23
    field :closing_minute, type: Integer, default: 59

    validates :day, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
    validates :opening_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
    validates :closing_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
    validates :opening_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
    validates :closing_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
    validate :opening_and_closing_hour

    belongs_to :restaurant

    private
    def opening_and_closing_hour
        t1 = Time.gm(2000,"jan",1,opening_hour,opening_minute)
        t2 = Time.gm(2000,"jan",1,closing_hour,closing_minute)
        self.errors.add :base, 'Opening hour has to be lower than closing hour' if t1 > t2
    end
end