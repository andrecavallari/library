# frozen_strint_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  enum :role, { librarian: 0, member: 1 }, default: :member
end
