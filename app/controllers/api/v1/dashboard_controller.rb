# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      def index
        if current_user.librarian?
          render json: DashboardForLibrarianService.call, status: :ok
        else
          render json: DashboardForMemberService.call(current_user), status: :ok
        end
      end
    end
  end
end
