# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  describe "GET /create" do
    let(:user) { create(:user, email: 'john@doe.com') }
    let(:json_response) { JSON.parse(response.body) }

    before { post '/api/v1/auth', params: params }

    context 'when user does not exists' do
      let(:params) { { email: 'maria@doe.com', password: 'password123' } }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to match('error' => 'Unauthorized')
      end
    end

    context 'when password is incorrect' do
      let(:params) { { email: user.email, password: 'wrongpassword' } }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to match('error' => 'Unauthorized')
      end
    end

    context 'when password is correct' do
      let(:params) { { email: user.email, password: 'password123' } }

      it 'returns ok status with token' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to match('token' => anything)
      end
    end
  end
end
