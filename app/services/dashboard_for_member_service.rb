# frozen_string_literal: true

class DashboardForMemberService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    borrows.map do |borrow|
      {
        id: borrow.book.id,
        book_title: borrow.book.title,
        borrowed_at: borrow.created_at,
        due_date: borrow.return_at,
        overdue: borrow.overdue?,
        due_today: borrow.due_today?
      }
    end
  end

  private
    def borrows = @borrows ||= @user.borrows.includes(:book)
end
