# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Book.accessible_by(current_ability)
        render json: books, status: :ok
      end

      def create
        authorize! :create, Book
        book = Book.new(book_params)

        if book.save
          render json: book, status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private
        def book_params
          params.require(:book).permit(:title, :author, :genre, :isbn, :copies)
        end
    end
  end
end
