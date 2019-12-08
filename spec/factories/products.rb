FactoryBot.define do
  factory :product do
    name { Faker::Restaurant.name }
    description { Faker::Restaurant.description }
    price { Faker::Number.between(from: 10, to: 120) }
    minimum_preparation_time { Faker::Number.between(from: 60, to: 300) }
  end
end
