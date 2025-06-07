# frozen_stirng_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "john#{n}@domain.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    role { 'member' }

    trait :librarian do
      role { 'librarian' }
    end
  end
end
