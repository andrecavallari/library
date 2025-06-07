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
    end
  end
end
