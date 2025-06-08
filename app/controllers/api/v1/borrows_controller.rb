# frozen_string_literal: true

module Api
  module V1
    class BorrowsController < ApplicationController
      def index
        borrows = Borrow.accessible_by(current_ability).includes(:book, :user)
        render json: borrows, include: [:book, :user]
      end

      def create
        authorize! :create, Borrow
        borrow = Borrow.new
        book = Book.accessible_by(current_ability).find(borrow_params[:book_id])

        return render json: { error: 'Book not available' }, status: :unprocessable_entity unless book.available?

        borrow.assign_attributes(user: current_user, book:)

        if borrow.save
          render json: borrow, status: :created, include: [:book, :user]
        else
          render json: borrow.errors, status: :unprocessable_entity
        end
      end

      def return_book
        authorize! :update, Borrow
        borrow = Borrow.accessible_by(current_ability).find(params[:id])

        return render json: { error: 'Book already returned' }, status: :unprocessable_entity if borrow.returned_at?

        if borrow.return_book!
          render json: borrow, status: :ok, include: [:book, :user]
        else
          render json: borrow.errors, status: :unprocessable_entity
        end
      end

      private

      def borrow_params
        params.require(:borrow).permit(:book_id)
      end
    end
  end
end
