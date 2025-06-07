# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:token) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.bbKAdeCTJq-6oBRg_cm98i6eFCKYdUGOfyUwgzy9_Gs' }
  let(:payload) { { user_id: 1 } }
  before { stub_const('JsonWebToken::SECRET_KEY', 'test_secret_key') }


  describe '.encode' do
    subject { JsonWebToken.encode(payload) }
    before { stub_const('JsonWebToken::SECRET_KEY', 'test_secret_key') }

    it { is_expected.to eq(token) }
  end

  describe '.decode' do
    subject { JsonWebToken.decode(token).first }

    context 'when the token is valid' do
      it { is_expected.to eq(payload.with_indifferent_access) }
    end

    context 'when the token is invalid' do
      it 'raises an error for an invalid token' do
        expect { JsonWebToken.decode('invalid.token') }.to raise_error(JWT::DecodeError)
      end
    end
  end
end
