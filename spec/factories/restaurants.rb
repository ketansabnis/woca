FactoryBot.define do
    factory :restaurant do
      name { Faker::Company.name }
      description { Faker::Company.bs }
      phone {Faker::PhoneNumber.cell_phone.tr('^0-9', '')}
      email {Faker::Internet.safe_email}
      
      after(:build) do |restaurant|
        restaurant.status = Company.available_statuses.find{|x| x[:default] == true}[:id]
      end

      after(:create) do |restaurant|
        restaurant.logo = Asset.new
        restaurant.logo.remote_file_url = Faker::Company.logo
        restaurant.logo.save
      end
    end
  end
  