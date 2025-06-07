# frozen_string_literal: true

module Warden
  module Strategies
    class JwtStrategy < Warden::Strategies::Base
      def valid? = bearer_token.present?

      def authenticate!
        decoded, = JsonWebToken.decode(bearer_token)
        id = decoded&.with_indifferent_access&.dig(:id)
        success! User.find(id)
      rescue JWT::DecodeError => e
        fail! e.message
      end

      def bearer_token
        request.env['HTTP_AUTHORIZATION']&.split&.last
      end
    end
  end
end
