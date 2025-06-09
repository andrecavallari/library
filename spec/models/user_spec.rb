# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    describe 'uniqueness of email' do
      let!(:user) { create(:user, email: 'john@domain.com') }
      let(:other) { build(:user, email: 'john@domain.com') }

      it 'validates uniqueness of email' do
        expect { other.save! }.to raise_error(ActiveRecord::RecordInvalid, /Email has already been taken/)
      end
    end
  end

  describe '.roles' do
    it { is_expected.to define_enum_for(:role).with_values(librarian: 0, member: 1) }
  end
end
