# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    full_name    { Faker::Name.name }
    email        { Faker::Internet.email(name: full_name, domain: 'company.com') }
    password     { Faker::Internet.password }
    gender       { Faker::Gender.binary_type.downcase }
    department   { Faker::Job.field }
    phone_number { Faker::PhoneNumber.phone_number }
    address      { Faker::Address.full_address }
    is_admin     { false }
    created_at   { Time.now }
    updated_at   { Time.now }

    trait :as_admin do
      is_admin { true }
    end
  end
end
