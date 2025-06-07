# frozen_string_literal: true

FactoryBot.define do
  factory :borrow do
    association :user, factory: :user, strategy: :build
    association :book, factory: :book, strategy: :build

    trait :with_user do
      user { create(:user) }
    end

    trait :with_book do
      book { create(:book) }
    end
  end
end
