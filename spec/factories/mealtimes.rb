FactoryBot.define do
  factory :mealtime do
    name { %w(lunch breakfast all-day snacks).sample }
  end
end