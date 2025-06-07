# frozen_sring_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate!, only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(id: user.id, exp: 24.hours.from_now.to_i)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
