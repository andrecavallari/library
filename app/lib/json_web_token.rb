# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', 'development_secret_key')

  def self.encode(payload)
    JWT.encode(payload.merge(exp: 1.hour.from_now.to_i), SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
  end
end
