# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    sequence(:isbn) { |n| "978-3-16-#{n.to_s.rjust(10, '0')}" }
    copies { rand(1..5) }

    trait :unavailable do
      copies { 0 }
    end
  end
end
