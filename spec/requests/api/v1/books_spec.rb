require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  describe "GET /index" do
    context 'when user is not logged in' do
      it 'returns an unauthorized status' do
        get api_v1_books_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is a member' do
      let(:member) { create(:user, role: :member) }
      let(:token) { JsonWebToken.encode(id: member.id) }

      before do
        create_list(:book, 3)
        create_list(:book, 2, :unavailable)
        get api_v1_books_path, headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns a list of available books' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    context 'when user is a librarian' do
      let(:librarian) { create(:user, role: :librarian) }
      let(:token) { JsonWebToken.encode(id: librarian.id) }

      before do
        create_list(:book, 5)
        create_list(:book, 2, :unavailable)
        get api_v1_books_path, headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns a list of all books' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(7)
      end
    end
  end

  describe "POST /create" do
    subject(:action) { post api_v1_books_path, params: valid_attributes }
    let(:member) { create(:user, role: :member) }
    let(:librarian) { create(:user, role: :librarian) }
    let(:json_response) { JSON.parse(response.body) }

    let(:valid_attributes) do
      {
        book: {
          title: "Sample Book",
          author: "Sample Author",
          genre: "Fiction",
          isbn: "1234567890",
          copies: 3
        }
      }
    end

    context 'when user is not logged in' do
      it 'returns an unauthorized status' do
        expect { action }.not_to change(Book, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is a member' do
      subject(:action) { post api_v1_books_path, params: valid_attributes, headers: {
        'Authorization': "Bearer #{token}"
      }}

      let(:token) { JsonWebToken.encode(id: member.id) }

      it 'returns a forbidden status' do
        expect { action }.not_to change(Book, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is a librarian' do
      subject(:action) { post api_v1_books_path, params: valid_attributes, headers: {
        'Authorization': "Bearer #{token}"
      }}

      let(:token) { JsonWebToken.encode(id: librarian.id) }

      it 'creates a new book' do
        expect { action }.to change(Book, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response['title']).to eq(valid_attributes[:book][:title])
      end
    end
  end
end
