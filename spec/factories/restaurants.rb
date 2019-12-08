FactoryBot.define do
    factory :restaurant do
      name { Faker::Company.name }
      description { Faker::Company.bs }
      phone {Faker::PhoneNumber.cell_phone.tr('^0-9', '')}
      email {Faker::Internet.safe_email}
      
      after(:build) do |restaurant|
        restaurant.status = Company.available_statuses.find{|x| x[:default] == true}[:id]
        restaurant.address = FactoryBot.build(:address)
      end

      after(:create) do |restaurant|
        restaurant.logo = Asset.new
        restaurant.logo.remote_file_url = Faker::Company.logo
        restaurant.logo.save
      end

      trait :with_products do
        after(:create) do |restaurant|
          mealtimes = []
          %w(lunch breakfast all-day snacks).each do |ml|
            ml_o = Mealtime.where(name: ml).first
            ml_o = Mealtime.create(name: ml) if ml_o.blank?
            mealtimes << ml_o
          end
          restaurant.categories << FactoryBot.create_list(:category, 4)
          restaurant.products << FactoryBot.create_list(:product, 20, category: restaurant.categories.sample, mealtime: mealtimes.sample)
        end
      end
    end
  end
  