require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  describe 'GET /snippets/:snippet_id/comments.json' do
    context 'when the specified snippet exists' do
      let(:snippet) { build(:snippet) }

      before do
        comments = create_pair(:comment, snippet: snippet)
        get "/snippets/#{comments.first.snippet_id}/comments.json"
      end

      it 'returns an array of comments where each element has comment attributes' do
        expect(response.status).to eq 200

        comments = JSON.parse(response.body)
        expect(comments.size).to eq 2

        expected_json = [
          {
            id: Numeric,
            content: String,
            author: {
              id: Numeric,
              name: String,
            },
            snippet_id: snippet.id
          }
        ] * 2
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specified snippet does not exist' do
      before do
        get '/snippets/1/comments.json'
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'GET /comments/:id.json' do
    let(:comment) { create(:comment) }

    context 'when the specified comment exist' do
      it 'returns the comment attributes' do
        get "/comments/#{comment.id}.json"

        expect(response.status).to eq 200

        expected_json = {
          id: comment.id,
          content: comment.content,
          author: {
            id: comment.comment_author.id,
            name: comment.comment_author.name
          },
          snippet_id: comment.snippet.id
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specified comemnt does not exist' do
      before do
        get '/comments/1.json'
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'POST /snippets/:snippet_id/comments.json' do
    include_context 'the user has the authentication token'

    let(:snippet_author) { create(:user) }
    let(:snippet) { create(:snippet, author: snippet_author) }
    let(:comment_attributes) { attributes_for(:comment) }
    let(:comment_params) {
      {
        comment: {
          content: comment_attributes[:content],
          comment_author_id: user.id
        }
      }
    }

    context 'when the specified snippet exists' do
      it 'creates the comment and returns its attributes' do
        expect {
          post "/snippets/#{snippet.id}/comments.json", params: comment_params, headers: authenticated_header
        }.to change(Comment, :count).by 1

        expect(response.status).to eq 201

        expected_json = {
          id: Numeric,
          content: comment_attributes[:content],
          author: {
            id:   user.id,
            name: user.name
          },
          snippet_id: snippet.id
        }
        expect(response.body).to be_json_as expected_json
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          post "/snippets/#{snippet.id}/comments.json", params: comment_params, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified snippet does not exists' do
      before do
        post '/snippets/1/comments.json', params: comment_params, headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before do
        comment_params[:comment][:content] = ''
        post "/snippets/#{snippet.id}/comments.json", params: comment_params, headers: authenticated_header
      end

      it 'returns an error' do
        expect(response.status).to eq 400

        expected_json = {
          content: ["can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when parameters are empty' do
      before do
        post "/snippets/#{snippet.id}/comments.json", params: {}, headers: authenticated_header
      end

      include_examples 'Required parameters are missing'
    end
  end

  describe 'PATCH /comments/:id.json' do
    include_context 'the user has the authentication token'

    let(:comment) { create(:comment, comment_author: user) }
    let(:comment_params) {
      {
        comment: {
          content: 'Modfied Comment'
        }
      }
    }

    context 'when the specified comment exists' do
      it 'updates the comment' do
        patch "/comments/#{comment.id}.json", params: comment_params, headers: authenticated_header

        expect(response.status).to eq 200

        expected_json = {
          id: comment.id,
          content: comment_params[:comment][:content],
          author: {
            id: comment.comment_author.id,
            name: comment.comment_author.name,
          },
          snippet_id: comment.snippet.id
        }
        expect(response.body).to be_json_as expected_json
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          patch "/comments/#{comment.id}.json", params: comment_params, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified comment does not exist' do
      before { patch '/comments/1.json', params: comment_params, headers: authenticated_header }

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before do
        comment_params[:comment][:content] = ''
        patch "/comments/#{comment.id}.json", params: comment_params, headers: authenticated_header
      end

      it 'returns an error' do
        expect(response.status).to eq 400

        expected_json = {
          content: ["can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when parameters are empty' do
      before { patch "/comments/#{comment.id}.json", params: {}, headers: authenticated_header }

      include_examples 'Required parameters are missing'
    end
  end

  describe 'DELETE /comments/:id.json' do
    include_context 'the user has the authentication token'

    context 'when the specified comment exists' do
      let!(:comment) { create(:comment, comment_author: user) }

      it 'destroy the comment' do
        expect {
          delete "/comments/#{comment.id}.json", headers: authenticated_header
        }.to change(Comment, :count).by -1

        expect(response.status).to eq 204
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          delete "/comments/#{comment.id}.json", headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified comment does not exist' do
      before { delete '/comments/1.json', headers: authenticated_header }

      include_examples 'The resource is not found'
    end
  end
end
