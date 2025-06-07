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
        borrow.user = current_user
        borrow.book = book

        if borrow.save
          render json: borrow, status: :created, include: [:book, :user]
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
