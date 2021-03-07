# frozen_string_literal: true

FactoryBot.define do
  factory :assignment do
    reviewer { association(:employee) }
    reviewee { association(:employee) }
    creator  { association(:employee,:as_admin) }

    trait :with_reviews do
      reviews do
        Array.new(2) { association(:review, assignment: instance) }
      end
    end
  end
end
