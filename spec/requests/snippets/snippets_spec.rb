require 'rails_helper'

RSpec.describe 'Snippet API', type: :request do
  describe 'GET /snippets/:id.json' do
    context 'when the specified snippet exists' do
      let(:snippet) { create(:snippet) }

      before do
        get "/snippets/#{snippet.id}.json"
      end

      it 'returns 200 OK' do
        expect(response.status).to eq 200
      end

      it 'returns the snippet attributes' do
        expect(response.body).to be_json_as(
                                   {
                                     id:      snippet.id,
                                     title:   snippet.title,
                                     content: snippet.content,
                                     author: {
                                       id:   snippet.author.id,
                                       name: snippet.author.name
                                     }
                                   })
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
      let(:user) { create(:user) }

      before do
        create_list(:snippet, 10, author: user)
        get "/users/#{user.id}/snippets.json"
      end

      it 'returns 200 OK' do
        expect(response.status).to eq 200
      end

      it 'returns an array including 10 snippets' do
        snippets = JSON.parse(response.body)
        expect(snippets.size).to eq 10
      end

      it 'returns an array where each element has snippet attributes' do
        expected_json = [
          {
            id:      Numeric,
            title:   String,
            content: String,
            author: {
              id:   user.id,
              name: user.name
            }
          }] * 10
        expect(response.body).to be_json_as(expected_json)
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
    let(:users) { create_list(:user, 5) }

    before do
      5.times { |n| create_list(:snippet, 10, author: users[n]) }
      get "/snippets.json"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
    end

    it 'returns an array including 50 snippets' do
      snippets = JSON.parse(response.body)
      expect(snippets.size).to eq 50
    end

    it 'returns an array where each element has snippet attributes' do
      expected_json = [
        {
          id:      Numeric,
          title:   String,
          content: String,
          author: {
            id:   Numeric,
            name: String
          }
        }] * 50
      expect(response.body).to be_json_as(expected_json)
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
    let(:user) { create(:user) }

    context 'when the specified user exists and parameters are valid' do
      it 'returns 201 Created' do
        post "/users/#{user.id}/snippets.json", params: snippet_params
        expect(response.status).to eq 201
      end

      it 'creates a snippet' do
        expect  {
          post "/users/#{user.id}/snippets.json", params: snippet_params
        }.to change(Snippet, :count).by(1)
      end

      it 'returns the created snippet attributes' do
        post "/users/#{user.id}/snippets.json", params: snippet_params
        expect(response.body).to be_json_as(
                                   {
                                     id:      Numeric,
                                     title:   snippet_attributes[:title],
                                     content: snippet_attributes[:content],
                                     author: {
                                       id:   user.id,
                                       name: user.name
                                     }
                                   })
      end
    end

    context 'when the specified user does not exist' do
      before do
        post '/users/1/snippets.json', params: snippet_params
      end

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before do
        post "/users/#{user.id}/snippets.json", params: snippet_params.merge(snippet: { content: ''})
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns an error' do
        expect(response.body).to be_json_as(
                                   {
                                     content: ["can't be blank"]
                                   }
                                 )
      end
    end

    context 'when parameters are empty' do
      before do
        post "/users/#{user.id}/snippets.json", params: {}
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns an error' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
    end
  end

  describe 'PATCH /snippets/:id' do
    let(:snippet) { create(:snippet) }
    let(:snippet_params) {
      { snippet:
          {
            title: updated_title
          }
      }
    }
    let(:updated_title) { 'Updated Title' }

    context 'when the specified snippet exists and parameters are valid' do
      before do
        patch "/snippets/#{snippet.id}.json", params: snippet_params
      end

      it 'returns 200 OK' do
        expect(response.status).to eq 200
      end

      it 'updates the snippet' do
        snippet.reload
        expect(snippet.title).to eq updated_title
      end

      it 'returns the updated snippet attributes' do
        expect(response.body).to be_json_as(
                                   {
                                     id:      snippet.id,
                                     title:   updated_title,
                                     content: snippet.content,
                                     author:  {
                                       id:   snippet.author.id,
                                       name: snippet.author.name
                                     }
                                   })
      end
    end

    context 'when the specified snippet does not exists' do
      before { patch '/snippets/1.json', params: snippet_params }

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before { patch "/snippets/#{snippet.id}.json", params: snippet_params.merge(snippet: { content: '' }) }

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns an error' do
        expect(response.body).to be_json_as(
                                   {
                                     content: ["can't be blank"]
                                   }
                                 )
      end
    end

    context 'when parameters are empty' do
      before { patch "/snippets/#{snippet.id}.json", params: {} }

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns an error' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
    end
  end

  describe 'DELETE /snippets/:snippet_id' do
    context 'when the specified snippet exists' do
      let!(:snippet) { create(:snippet) }

      it 'returns 204 No Content' do
        delete "/snippets/#{snippet.id}.json"
        expect(response.status).to eq 204
      end

      it 'destroys the snippet' do
        expect {
          delete "/snippets/#{snippet.id}.json"
        }.to change(Snippet, :count).by(-1)
      end
    end

    context 'when the specified user does not exist' do
      before { delete '/snippets/1.json' }

      include_examples 'The resource is not found'
    end
  end
end
