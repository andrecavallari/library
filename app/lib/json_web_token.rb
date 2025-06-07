# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', 'development_secret_key')

  def self.encode(payload) = JWT.encode(payload, SECRET_KEY)
  def self.decode(token) = JWT.decode(token, SECRET_KEY)
end
