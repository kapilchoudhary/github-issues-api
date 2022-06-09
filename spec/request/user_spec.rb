require 'rails_helper'

RSpec.describe 'issues API', type: :request do
# initialize test data
  let(:user) { User.create(email: 'test@example.com', password: '123456') }
  let(:all_users) { User.all }
  let(:token) { JsonWebToken.encode(email: user.email) }

  # Test suite for GET /users
  describe 'GET /users' do
    # make HTTP get request before each example
    before { get '/users', headers: { 'Authorization' => token } }

    it 'returns users' do
      # Note `json` is a custom helper to parse JSON responses
      result = JSON(response.body)
      expect(result).not_to be_empty
      expect(result.size).to eq(all_users.count)
    end
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user.id}", headers: { 'Authorization' => token } }

    context 'when the record exists' do
      it 'returns the user' do
        result = JSON(response.body)
        expect(result).not_to be_empty
        expect(result['id']).to eq(user.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    # valid payload
    let(:valid_attributes) { { user: { email: 'learn@gmail.com', password: '123456' }} }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a issue' do
        result = JSON(response.body)
        expect(result['email']).to eq('learn@gmail.com')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { user: { name: 'John Doe' } } }

    context 'when the record exists' do
      before { put "/users/#{user.id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'updates the record' do
        expect(response.body.present?).to be(true)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
