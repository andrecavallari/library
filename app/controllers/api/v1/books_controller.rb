# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        render json: { message: 'Welcome to the Books API' }, status: :ok
      end
    end
  end
end
