# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:genre) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:isbn) }

    describe 'isbn uniqueness' do
      subject { create(:book) }

      it { is_expected.to validate_uniqueness_of(:isbn).case_insensitive }
    end
  end

  describe 'associations' do
    it { should have_many(:borrows) }
  end
end
