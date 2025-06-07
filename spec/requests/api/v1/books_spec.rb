require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  let(:json_response) { JSON.parse(response.body) }

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

  describe "GET /show" do
    subject(:action) { get api_v1_book_path(book.id), headers: { 'Authorization': "Bearer #{token}" } }
    let(:book) { create(:book) }
    let(:token) { JsonWebToken.encode(id: user.id) }

    before do
      action
    end

    context 'when user is not logged in' do
      subject(:action) { get api_v1_book_path(book.id) }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when book does not exist' do
      let(:book) { double('Book', id: 999) }
      let(:user) { create(:user, role: :member) }

      it 'returns a not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is a member and book is available' do
      let(:user) { create(:user, role: :member) }

      it 'returns the book details' do
        expect(response).to have_http_status(:ok)
        expect(json_response['title']).to eq(book.title)
        expect(json_response['author']).to eq(book.author)
      end
    end

    context 'when user is a member and book is unavailable' do
      let(:user) { create(:user, role: :member) }
      let(:book) { create(:book, :unavailable) }

      it 'returns the book details' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is a librarian and book is unavailable' do
      let(:user) { create(:user, role: :librarian) }
      let(:book) { create(:book, :unavailable) }

      it 'returns the book details' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is a librarian and book is available' do
      let(:user) { create(:user, role: :librarian) }

      it 'returns the book details' do
        expect(response).to have_http_status(:ok)
        expect(json_response['title']).to eq(book.title)
        expect(json_response['author']).to eq(book.author)
      end
    end
  end

  describe "POST /create" do
    subject(:action) { post api_v1_books_path, params: valid_attributes }
    let(:member) { create(:user, role: :member) }
    let(:librarian) { create(:user, role: :librarian) }

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

  describe "PUT /update" do
    subject(:action) { put api_v1_book_path(book.id), params: valid_attributes }
    let(:book) { create(:book) }
    let(:librarian) { create(:user, role: :librarian) }
    let(:token) { JsonWebToken.encode(id: librarian.id) }

    let(:valid_attributes) do
      {
        book: {
          title: "Updated Book Title",
          author: "Updated Author",
          genre: "Updated Genre",
          isbn: "0987654321",
          copies: 5
        }
      }
    end

    context 'when user is not logged in' do
      subject(:action) { put api_v1_book_path(book.id), params: valid_attributes }

      it 'returns an unauthorized status' do
        expect { action }.not_to change { book.reload.title }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is a member' do
      let(:member) { create(:user, role: :member) }
      let(:token) { JsonWebToken.encode(id: member.id) }

      subject(:action) { put api_v1_book_path(book.id), params: valid_attributes, headers: {
        'Authorization': "Bearer #{token}"
      }}

      it 'returns a forbidden status' do
        expect { action }.not_to change { book.reload.title }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is a librarian' do
      subject(:action) { put api_v1_book_path(book.id), params: valid_attributes, headers: {
        'Authorization': "Bearer #{token}"
      }}
      let(:token) { JsonWebToken.encode(id: librarian.id) }

      it 'updates the book' do
        expect { action }.to change { book.reload.title }.to(valid_attributes[:book][:title])
        expect(response).to have_http_status(:ok)
        expect(json_response['title']).to eq(valid_attributes[:book][:title])
      end
    end
  end

  describe 'DELETE /destroy' do
    subject(:action) { delete api_v1_book_path(book.id) }
    let!(:book) { create(:book) }
    let(:librarian) { create(:user, role: :librarian) }

    context 'when user is not logged in' do
      it 'returns an unauthorized status' do
        expect { action }.not_to change(Book, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when book does not exist' do
      let(:book) { double('Book', id: 999) }
      let(:user) { create(:user, role: :librarian) }
      let(:token) { JsonWebToken.encode(id: user.id) }
      subject(:action) { delete api_v1_book_path(book.id), headers: {
        'Authorization': "Bearer #{token}"
      }}

      it 'returns a not found status' do
        expect { action }.not_to change(Book, :count)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is a member' do
      let(:user) { create(:user, role: :member) }
      let(:token) { JsonWebToken.encode(id: user.id) }

      subject(:action) { delete api_v1_book_path(book.id), headers: {
        'Authorization': "Bearer #{token}"
      }}

      it 'returns a forbidden status' do
        expect { action }.not_to change(Book, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is a librarian' do
      subject(:action) { delete api_v1_book_path(book.id), headers: {
        'Authorization': "Bearer #{token}"
      }}
      let(:token) { JsonWebToken.encode(id: librarian.id) }

      it 'deletes the book' do
        expect { action }.to change(Book, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
