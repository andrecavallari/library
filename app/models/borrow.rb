# frozen_string_literal: true

class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true
  validate :already_borrowed, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { where('return_at < ?', Date.today).where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }

  def return_book!
    update(returned_at: Time.current)
  end

  private
    def already_borrowed
      if Borrow.active.where(user_id: user_id, book_id: book_id).exists?
        errors.add(:base, 'You have already borrowed this book')
      end
    end
end
