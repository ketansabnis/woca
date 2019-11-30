FactoryBot.define do
    factory :user do
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      phone {Faker::PhoneNumber.cell_phone.tr('^0-9', '')}
      email {Faker::Internet.safe_email}
      display_name {Faker::Name.name}
      married {Faker::Boolean.boolean}
      dob {Faker::Date.birthday(min_age: 18, max_age: 50)}
      deparment {Faker::Commerce.department(max: 1)}
      job_title {Faker::Job.title}
      manager_name {Faker::Name.name}
      manager_email {Faker::Internet.safe_email}
      manager_phone {Faker::PhoneNumber.cell_phone.tr('^0-9', '')}
      employee_id {Faker::Company.ein}
      time_zone {Faker::Address.time_zone}
      password {Faker::Internet.password}
      
      after(:build) do |user|
        user.gender = ['m', 'f', 'n'].sample if user.gender.blank?
        user.role = User.available_roles.find{|x| x[:default] == true}[:id]
        user.gender = User.available_genders.find{|x| x[:default] == true}[:id]
        user.status = User.available_statuses.find{|x| x[:default] == true}[:id]
      end
    end
  end
  