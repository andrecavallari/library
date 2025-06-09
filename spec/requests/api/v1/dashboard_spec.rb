# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Dashboard', type: :request do
  describe 'GET /api/v1/dashboard' do
    context 'when user is a librarian' do
      let(:librarian) { create(:user, :librarian) }

      before do
        create_list(:borrow, 3, :active)
        create_list(:borrow, 2, :overdue)
        create_list(:borrow, 1, :due_today)
        create_list(:borrow, 2, :returned)
        get '/api/v1/dashboard', headers: authorize(librarian)
      end

      it 'returns the dashboard data for the librarian', :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(json_response['books_count']).to eq(8)
        expect(json_response['borrowed_books_count']).to eq(6)
        expect(json_response['overdue_books_count']).to eq(2)
        expect(json_response['due_today_books_count']).to eq(1)
      end
    end

    context 'when user is a member' do
      let(:member) { create(:user, :member) }

      before do
        create_list(:borrow, 2, :active, user: member)
        get '/api/v1/dashboard', headers: authorize(member)
      end

      it 'returns the dashboard data for the member' do
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(2)
        expect(json_response.first['id']).to be_present
        expect(json_response.first['book_title']).to be_present
      end
    end
  end
end
