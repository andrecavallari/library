# frozen_strint_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :borrows, dependent: :destroy
  has_many :books, through: :borrows

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid email format' }
  validates :password, presence: true, length: { minimum: 6 }

  enum :role, { librarian: 0, member: 1 }, default: :member
end
