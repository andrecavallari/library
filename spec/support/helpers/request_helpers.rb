# frozen_strint_literal: true

module Helpers
  module RequestHelpers
    extend ActiveSupport::Concern

    included do
      let(:json_response) { JSON.parse(response.body) }
    end

    def authorize(user)
      token = JsonWebToken.encode(id: user.id)
      { 'Authorization': "Bearer #{token}" }
    end
  end
end
