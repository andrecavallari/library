# frozen_string_literal: true

FactoryBot.define do
  factory :borrow do
    user { association :user }
    book { association :book }

    trait :active do
      returned_at { nil }
      return_at { 1.week.from_now }
    end

    trait :overdue do
      returned_at { nil }
      return_at { 2.days.ago }
    end

    trait :due_today do
      returned_at { nil }
      return_at { Date.today }
    end

    trait :returned do
      returned_at { Time.current }
      return_at { 1.week.ago }
    end
  end
end
