require 'rails_helper'

RSpec.describe 'Snippet API', type: :request do
  describe 'GET /snippets/:id.json' do
    context 'when the specified snippet exists' do
      let(:snippet) { create(:snippet) }

      it 'returns the snippet attributes' do
        get "/snippets/#{snippet.id}.json"

        expect(response.status).to eq 200

        expected_json = {
          id:      snippet.id,
          title:   snippet.title,
          content: snippet.content,
          author: {
            id:   snippet.author.id,
            name: snippet.author.name
          }
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specified snippet does not exist' do
      before do
        get '/snippets/1.json'
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'GET /users/:user_id/snippets.json' do
    context 'when the specified user exists' do
      let(:user) { build(:user) }

      before do
        create_pair(:snippet, author: user)
        get "/users/#{user.id}/snippets.json"
      end

      it 'returns an array of snippets where each element has snippet attributes' do
        expect(response.status).to eq 200

        snippets = JSON.parse(response.body)
        expect(snippets.size).to eq 2

        expected_json = [
          {
            id:      Numeric,
            title:   String,
            content: String,
            author: {
              id:   user.id,
              name: user.name
            }
          }
        ] * 2
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specified user does not exist' do
      before do
        get '/users/1/snippets.json'
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'GET /snippets.json' do
    let(:users) { build_pair(:user) }

    before do
      users.size.times { |n| create_pair(:snippet, author: users[n]) }
      get "/snippets.json"
    end

    it 'returns an array of snippets where each element has snippet attributes' do
      expect(response.status).to eq 200

      snippets = JSON.parse(response.body)
      expect(snippets.size).to eq 4

      expected_json = [
        {
          id:      Numeric,
          title:   String,
          content: String,
          author: {
            id:   Numeric,
            name: String
          }
        }] * 4
      expect(response.body).to be_json_as expected_json
    end
  end

  describe 'POST /users/:user_id/snippets' do
    let(:snippet_attributes) { attributes_for(:snippet) }
    let(:snippet_params) {
      { snippet:
          {
            title:   snippet_attributes[:title],
            content: snippet_attributes[:content],
          }
      }
    }

    include_context 'the user has the authentication token'

    context 'when the specified user exists and parameters are valid' do
      it 'creates the snippet returns its attributes' do
        expect  {
          post "/users/#{user.id}/snippets.json", params: snippet_params, headers: authenticated_header
        }.to change(Snippet, :count).by 1

        expect(response.status).to eq 201

        expected_json = {
          id:      Numeric,
          title:   snippet_attributes[:title],
          content: snippet_attributes[:content],
          author: {
            id:   user.id,
            name: user.name
          }
        }
        expect(response.body).to be_json_as expected_json
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          post "/users/#{user.id}/snippets.json", params: snippet_params, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified user does not exist' do
      before do
        post "/users/#{User.last.id.succ}/snippets.json", params: snippet_params, headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      it 'returns an error' do
        post "/users/#{user.id}/snippets.json", params: snippet_params.merge(snippet: { content: '' }), headers: authenticated_header

        expect(response.status).to eq 400

        expected_json = {
          errors: ["content can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when parameters are empty' do
      before do
        post "/users/#{user.id}/snippets.json", params: {}, headers: authenticated_header
      end

      include_examples 'Required parameters are missing'
    end
  end

  describe 'PATCH /snippets/:id' do
    include_context 'the user has the authentication token'

    let(:snippet) { create(:snippet, author: user) }
    let(:snippet_params) {
      {
        snippet: {
          title: updated_title
        }
      }
    }
    let(:updated_title) { 'Updated Title' }

    context 'when the specified snippet exists and parameters are valid' do
      it 'updates the snippet and returns its attributes' do
        patch "/snippets/#{snippet.id}.json", params: snippet_params, headers: authenticated_header

        expect(response.status).to eq 200

        snippet.reload
        expect(snippet.title).to eq updated_title

        expected_json = {
          id:      snippet.id,
          title:   updated_title,
          content: snippet.content,
          author:  {
            id:   snippet.author.id,
            name: snippet.author.name
          }
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specified snippet does not exists' do
      before do
        patch '/snippets/1.json', params: snippet_params, headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      it 'returns an error' do
        patch "/snippets/#{snippet.id}.json", params: snippet_params.merge(snippet: { content: '' }), headers: authenticated_header

        expect(response.status).to eq 400

        expected_json = {
          errors: ["content can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when parameters are empty' do
      before do
        patch "/snippets/#{snippet.id}.json", params: {}, headers: authenticated_header
      end

      include_examples 'Required parameters are missing'
    end
  end

  describe 'DELETE /snippets/:snippet_id' do
    include_context 'the user has the authentication token'

    context 'when the specified snippet exists' do
      let!(:snippet) { create(:snippet, author: user) }

      it 'destroys the snippet' do
        expect {
          delete "/snippets/#{snippet.id}.json", headers: authenticated_header
        }.to change(Snippet, :count).by(-1)

        expect(response.status).to eq 204
      end
    end

    context 'when the specified user does not exist' do
      before { delete '/snippets/1.json', headers: authenticated_header }

      include_examples 'The resource is not found'
    end
  end
end
