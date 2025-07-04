# frozen_string_literal: true

class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book
  counter_culture :book,
    column_name: proc { |model| model.returned_at? ? nil : 'active_borrows_count' },
    column_names: {
      'returned_at IS NULL' => 'active_borrows_count'
    }

  validates :user_id, presence: true
  validates :book_id, presence: true
  validate :already_borrowed, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { where('return_at < ?', Date.today).where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  scope :due_today, -> { where(return_at: Date.today, returned_at: nil) }

  def overdue? = return_at < Date.today && returned_at.blank?
  def due_today? = return_at == Date.today && returned_at.blank?

  def return_book!
    return if returned_at.present?

    update(returned_at: Time.current)
  end

  private
    def already_borrowed
      if Borrow.active.where(user_id: user_id, book_id: book_id).exists?
        errors.add(:base, 'You have already borrowed this book')
      end
    end
end
