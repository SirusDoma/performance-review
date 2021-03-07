# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    association(:assignment)
    association(:question)

    answer { Faker::Lorem.paragraphs(number: 2).join }
  end
end

