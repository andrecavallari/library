# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Borrow, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'counter cache' do
    let!(:book) { create(:book) }
    let(:user) { create(:user) }
    let(:borrow) { build(:borrow, book:, user:) }

    it 'increments active_borrows_count on create' do
      expect { borrow.save }.to change { book.reload.active_borrows_count }.by(1)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:book_id) }

    context 'when already borrowed' do
      subject(:new_borrow) { build(:borrow, user:, book:) }
      let(:book) { create(:book) }
      let(:user) { create(:user) }
      let!(:borrow) { create(:borrow, user:, book:) }

      it 'does not allow borrowing the same book again' do
        is_expected.not_to be_valid
        expect(new_borrow.errors[:base]).to include('You have already borrowed this book')
      end
    end
  end

  describe 'scopes' do
    let!(:active_borrow) { create(:borrow, :active) }
    let!(:overdue_borrow) { create(:borrow, :overdue) }
    let!(:returned_borrow) { create(:borrow, :returned) }
    let!(:due_today_borrow) { create(:borrow, :due_today) }

    subject(:active) { Borrow.active }
    subject(:overdue) { Borrow.overdue }
    subject(:returned) { Borrow.returned }
    subject(:due_today) { Borrow.due_today }

    it '.active returns active borrows' do
      expect(active).to include(active_borrow, overdue_borrow, due_today_borrow)
      expect(active).not_to include(returned_borrow)
    end

    it '.overdue returns overdue borrows' do
      expect(overdue).to include(overdue_borrow)
      expect(overdue).not_to include(active_borrow, returned_borrow, due_today_borrow)
    end

    it '.returned returns returned borrows' do
      expect(returned).to include(returned_borrow)
      expect(returned).not_to include(active_borrow, overdue_borrow, due_today_borrow)
    end

    it '.due_today returns borrows due today' do
      expect(due_today).to include(due_today_borrow)
      expect(due_today).not_to include(active_borrow, overdue_borrow, returned_borrow)
    end
  end

  describe '#overdue?' do
    context 'when the borrow is overdue' do
      let(:borrow) { build(:borrow, :overdue) }
      it { expect(borrow.overdue?).to be true }
    end

    context 'when due today' do
      let(:borrow) { build(:borrow, :due_today) }
      it { expect(borrow.overdue?).to be false }
    end

    context 'when returned' do
      let(:borrow) { build(:borrow, :returned) }
      it { expect(borrow.overdue?).to be false }
    end

    context 'when active' do
      let(:borrow) { build(:borrow, :active) }
      it { expect(borrow.overdue?).to be false }
    end
  end

  describe '#due_today?' do
    context 'when in the past' do
      let(:borrow) { build(:borrow, :overdue) }
      it { expect(borrow.due_today?).to be false }
    end

    context 'when due today' do
      let(:borrow) { build(:borrow, :due_today) }
      it { expect(borrow.due_today?).to be true }
    end

    context 'when returned' do
      let(:borrow) { build(:borrow, :returned) }
      it { expect(borrow.due_today?).to be false }
    end

    context 'when due in the future' do
      let(:borrow) { build(:borrow, :active) }
      it { expect(borrow.due_today?).to be false }
    end
  end

  describe '#return_book!' do
    subject(:return_book) { borrow.return_book! && borrow.reload }

    context 'when the borrow is active' do
      let(:borrow) { create(:borrow, :active) }

      it { expect { return_book }.to change(borrow, :returned_at).from(nil).to(be_within(1.minute).of(Time.current)) }
    end

    context 'when the borrow is already returned' do
      let(:borrow) { create(:borrow, :returned) }

      it { expect { return_book }.not_to change(borrow, :returned_at) }
    end
  end
end
