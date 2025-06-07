# frozen_string_literal: true

require 'warden/strategies/jwt_strategy'

Rails.application.config.middleware.insert_before Rack::Head, Warden::Manager do |manager|
  manager.default_strategies :jwt
  manager.failure_app = ->(env) do
    env['warden.options'] = { action: 'unauthenticated' }
    [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
  end
end

Warden::Strategies.add :jwt, Warden::Strategies::JwtStrategy
