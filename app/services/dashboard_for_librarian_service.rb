# frozen_string_literal: true

class DashboardForLibrarianService < ApplicationService
  def call
    {
      books_count: total_books,
      borrowed_books_count: active_borrows.count,
      overdue_books_count: overdue_borrows.count,
      due_today_books_count: due_today_borrows.count,
      overdue_books: overdue_books,
      due_today_books: due_today_books
    }
  end

  private
    def total_books = Book.count
    def overdue_borrows = @overdue_borrows ||= Borrow.overdue.includes(:book, :user)
    def active_borrows = Borrow.active
    def due_today_borrows = @due_today_borrows ||= Borrow.due_today.includes(:book)

    def overdue_books
      overdue_borrows.map do |borrow|
        {
          borrow_id: borrow.id,
          book_id: borrow.book.id,
          user_id: borrow.user.id,
          book_title: borrow.book.title,
          user_name: borrow.user.name,
          user_email: borrow.user.email,
          return_at: borrow.return_at.strftime('%Y-%m-%d')
        }
      end
    end

    def due_today_books
      due_today_borrows.map do |borrow|
        {
          borrow_id: borrow.id,
          bookd_id: borrow.book.id,
          user_id: borrow.user.id,
          book_title: borrow.book.title,
          user_name: borrow.user.name,
          user_email: borrow.user.email,
          return_at: borrow.return_at.strftime('%Y-%m-%d')
        }
      end
    end
end
