# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate!, only: [:create]

      def create
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(id: user.id, exp: 24.hours.from_now.to_i)
          render json: { token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
