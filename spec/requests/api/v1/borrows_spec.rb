# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Borrows', type: :request do
  describe 'POST /api/v1/borrows' do
    let!(:user) { create(:user, :member) }
    let!(:book) { create(:book, copies: 1) }
    let(:params) do
      {
        borrow: {
          book_id: book.id
        }
      }
    end

    subject(:action) { post api_v1_borrows_path, params:, headers: authorize(user) }

    context 'when user is unauthenticated' do
      it 'returns unauthorized status' do
        post api_v1_borrows_path, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      it 'returns forbidden status' do
        expect { action }.not_to change(Borrow, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is a member' do
      let(:user) { create(:user, :member) }

      context 'when the book is available' do
        it 'creates a borrow record' do
          expect { action }.to change(Borrow, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(json_response['book']['id']).to eq(book.id)
          expect(json_response['user']['id']).to eq(user.id)
        end
      end

      context 'when the book is not available' do
        before do
          book.update(copies: 0)
        end

        it 'does not create a borrow record' do
          expect { action }.not_to change(Borrow, :count)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when the book does not exist' do
        let(:params) do
          {
            borrow: {
              book_id: 0
            }
          }
        end

        it 'returns not found status' do
          expect { action }.not_to change(Borrow, :count)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when the user already borrowed the book' do
        before do
          create(:borrow, user:, book:)
        end

        it 'returns unprocessable entity status' do
          expect { action }.not_to change(Borrow, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to match('base' => ['You have already borrowed this book'])
        end
      end
    end
  end

  describe 'GET /api/v1/borrows' do
    context 'when user is unauthenticated' do
      it 'returns unauthorized status' do
        get api_v1_borrows_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      let(:book1) { create(:book, copies: 2) }
      let(:book2) { create(:book, copies: 1) }
      let(:user1) { create(:user, :member) }
      let(:user2) { create(:user, :member) }
      let(:librarian) { create(:user, :librarian) }

      before do
        create(:borrow, user: user1, book: book1)
        create(:borrow, user: user2, book: book2)
      end

      context 'when user is a member' do
        before do
          get api_v1_borrows_path, headers: authorize(user1)
        end

        it 'returns only the borrows of the user' do
          expect(response).to have_http_status(:ok)
          expect(json_response.size).to eq(1)
        end
      end

      context 'when user is a librarian' do
        before do
          get api_v1_borrows_path, headers: authorize(librarian)
        end

        it 'returns all borrows' do
          expect(response).to have_http_status(:ok)
          expect(json_response.size).to eq(2)
        end
      end
    end
  end

  describe 'PATCH /api/v1/borrows/:id/return_book' do
    let!(:user) { create(:user, :member) }
    let!(:book) { create(:book, copies: 1) }
    let!(:borrow) { create(:borrow, user:, book:) }

    subject(:action) { patch return_book_api_v1_borrow_path(borrow), headers: authorize(user) }

    context 'when user is unauthenticated' do
      it 'returns unauthorized status' do
        patch return_book_api_v1_borrow_path(borrow)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is a librarian' do
      let(:user) { create(:user, :librarian) }

      context 'when the book is not returned' do
        it 'upadtes returned_at' do
          expect { action }.to change { borrow.reload.returned_at }.from(nil).to(be_present)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when the book is already returned' do
        before do
          borrow.update(returned_at: Time.current)
        end

        it 'returns unprocessable entity status' do
          expect { action }.not_to change { borrow.reload.returned_at }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to match('error' => 'Book already returned')
        end
      end
    end

    context 'when the user is a member' do
      let(:user) { create(:user, :member) }

      it 'returns forbidden' do
        expect { action }.not_to change { borrow.reload.returned_at }.from(nil)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
