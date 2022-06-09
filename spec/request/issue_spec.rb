require 'rails_helper'

RSpec.describe 'issues API', type: :request do
# initialize test data
  let!(:issues) { create_list(:issue, 10) }
  let(:issue_id) { issues.first.id }
  let(:user) { User.create(email: 'test@example.com', password: '123456') }
  let(:token) { JsonWebToken.encode(email: user.email) }

  # Test suite for GET /issues
  describe 'GET /issues' do
    # make HTTP get request before each example
    before { get '/issues', headers: { 'Authorization' => token } }

    it 'returns issues' do
      # Note `json` is a custom helper to parse JSON responses
      result = JSON(response.body)
      expect(result).not_to be_empty
      expect(result.size).to eq(2)
    end
  end

  # Test suite for GET /issues/:id
  describe 'GET /issues/:id' do
    before { get "/issues/#{issue_id}", headers: { 'Authorization' => token } }

    context 'when the record exists' do
      it 'returns the issue' do
        result = JSON(response.body)
        expect(result).not_to be_empty
        expect(result['id']).to eq(issue_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:issue_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for POST /issues
  describe 'POST /issues' do
    # valid payload
    let(:valid_attributes) { { issue: { title: 'Learn Elm', description: 'lorem' } } }

    context 'when the request is valid' do
      before { post '/issues', params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a issue' do
        result = JSON(response.body)
        expect(result['title']).to eq('Learn Elm')
        expect(result['description']).to eq('lorem')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/issues', params: { issue: { description: 'lorem' } }, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"title\":[\"can't be blank\"]}")
      end
    end
  end

  # Test suite for PUT /issues/:id
  describe 'PUT /issues/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/issues/#{issue_id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /issues/:id
  describe 'DELETE /issues/:id' do
    before { delete "/issues/#{issue_id}", headers: { 'Authorization' => token } }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
