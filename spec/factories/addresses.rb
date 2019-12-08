FactoryBot.define do
    factory :address do
        address1 { Faker::Address.street_address }
        address2 { Faker::Address.secondary_address }
        city { Faker::Address.city }
        state { Faker::Address.state }
        country { Faker::Address.country }
        zip { Faker::Address.zip }
    end
  end
  