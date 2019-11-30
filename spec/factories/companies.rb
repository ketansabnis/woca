FactoryBot.define do
    factory :company do
      name { Faker::Company.name }
      industry { Faker::Company.industry }
      description { Faker::Company.bs }
      
      after(:build) do |company|
        company.status = Company.available_statuses.find{|x| x[:default] == true}[:id]
      end

      after(:create) do |company|
        company.logo = Asset.new
        company.logo.remote_file_url = Faker::Company.logo
        company.logo.save

        create :user, company: company, role: 'company_admin'
        create_list :user, 3, company: company, role: 'user'
      end
    end
  end
  