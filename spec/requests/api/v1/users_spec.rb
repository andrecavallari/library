# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /api/v1/users' do
    subject(:action) { post api_v1_users_path, params: payload }
    let(:json_response) { JSON.parse(response.body) }

    context 'when email is already taken' do
      let!(:user) { create(:user, email: 'taken@domain.com') }
      let(:payload) do
        {
          name: 'Test User',
          email: user.email,
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'returns an error message' do
        expect { action }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('Email has already been taken')
      end
    end

    context 'when password confirmation does not match' do
      let(:payload) do
        {
          name: 'Test User',
          email: 'john@doe.com',
          password: 'password123',
          password_confirmation: 'different_password'
        }
      end

      it 'returns an error message' do
        expect { action }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Password confirmation doesn't match Password")
      end
    end

    context 'when email format is invalid' do
      let(:payload) do
        {
          name: 'Test User',
          email: 'invalid_email_format',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'returns an error message' do
        expect { action }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('Email Invalid email format')
      end
    end

    context 'when payload is all ok and user does not exists' do
      let(:payload) do
        {
          name: 'Test User',
          email: 'john@doe.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'creates a new user and returns a token' do
        expect { action }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response).to match('token' => anything)
      end
    end
  end
end
