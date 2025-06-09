# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Book.accessible_by(current_ability)
        books = books.search(params[:query]) if params[:query].present?
        render json: books, status: :ok
      end

      def show
        book = Book.accessible_by(current_ability).find(params[:id])
        render json: book, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Book not found' }, status: :not_found
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

      def update
        authorize! :update, Book
        book = Book.accessible_by(current_ability).find(params[:id])
        if book.update(book_params)
          render json: book, status: :ok
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, Book
        book = Book.accessible_by(current_ability).find(params[:id])
        if book.destroy
          head :no_content
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
