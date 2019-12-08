FactoryBot.define do
  factory :category do
    name { "#{Faker::Restaurant.type}_#{Faker::Number.between(from: 1, to: 100)}" }
    description { Faker::Restaurant.description }
  end
end