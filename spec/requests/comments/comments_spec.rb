require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  describe 'GET /snippets/:snippet_id/comments.json' do
    context 'when the specified snippet exists' do
      let(:snippet) { create(:snippet) }

      before do
        create_list(:comment, 10, snippet: snippet)
        get "/snippets/#{snippet.id}/comments.json"
      end

      it 'returns 200 OK' do
        expect(response.status).to eq 200
      end

      it 'returns an array including 10 comments' do
        comments = JSON.parse(response.body)
        expect(comments.size).to eq 10
      end

      it 'returns an array where each element has snippet attributes' do
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
        ] * 10
        expect(response.body).to be_json_as(expected_json)
      end
    end

    context 'when the specified snippet does not exist' do
      before { get '/snippets/1/comments.json' }

      include_examples 'The resource is not found'
    end
  end

  describe 'GET /comments/:id.json' do
    let(:comment) { create(:comment) }

    context 'when the specified comment exist' do
      before { get "/comments/#{comment.id}.json" }

      it 'returns 200 OK' do
        expect(response.status).to eq 200
      end

      it 'returns the comment attributes' do
        expect(response.body).to be_json_as(
                                   {
                                     id: comment.id,
                                     content: comment.content,
                                     author: {
                                       id: comment.comment_author.id,
                                       name: comment.comment_author.name
                                     },
                                     snippet_id: comment.snippet.id
                                   })
      end
    end

    context 'when the specified comemnt does not exist' do
      before { get '/comments/1.json' }

      include_examples 'The resource is not found'
    end
  end

  describe 'POST /snippets/:snippet_id/comments.json' do
    let(:comment_author) { create(:user) }
    let(:snippet) { create(:snippet) }
    let(:comment_attributes) { attributes_for(:comment) }
    let(:comment_params) {
      {
        comment: {
          content: comment_attributes[:content],
          comment_author_id: comment_author.id
        }
      }
    }

    context 'when the specified snippet exists' do
      it 'returns 201 Created' do
        post "/snippets/#{snippet.id}/comments.json", params: comment_params
        expect(response.status).to eq 201
      end

      it 'creates a comment' do
        expect {
          post "/snippets/#{snippet.id}/comments.json", params: comment_params
        }.to change(Comment, :count).by(1)
      end

      it 'returns the comment attributes' do
        post "/snippets/#{snippet.id}/comments.json", params: comment_params
        expect(response.body).to be_json_as(
                                   {
                                     id: Numeric,
                                     content: comment_attributes[:content],
                                     author: {
                                       id: comment_author.id,
                                       name: comment_author.name
                                     },
                                     snippet_id: snippet.id
                                   })
      end
    end

    context 'when the specified snippet does not exists' do
      before { post '/snippets/1/comments.json', params: comment_params }

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before do
        comment_params[:comment][:content] = ''
        post "/snippets/#{snippet.id}/comments.json", params: comment_params
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
      before { post "/snippets/#{snippet.id}/comments.json", params: {} }

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns errors' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
    end
  end

  describe 'PATCH /comments/:id.json' do
    let(:comment) { create(:comment) }
    let(:comment_params) {
      {
        comment: {
          content: 'Modfied Comment'
        }
      }
    }

    context 'when the specified comment exists' do
      it 'returns 200 OK' do
        patch "/comments/#{comment.id}.json", params: comment_params
        expect(response.status).to eq 200
      end

      it 'updates the comment' do
        patch "/comments/#{comment.id}.json", params: comment_params
        expect(response.body).to be_json_as(
                                   {
                                     id: comment.id,
                                     content: comment_params[:comment][:content],
                                     author: {
                                       id: comment.comment_author.id,
                                       name: comment.comment_author.name,
                                     },
                                     snippet_id: comment.snippet.id
                                   }
                                 )
      end
    end

    context 'when the specified comment does not exist' do
      before { patch '/comments/1.json', params: comment_params }

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      before do
        comment_params[:comment][:content] = ''
        patch "/comments/#{comment.id}.json", params: comment_params
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
      before { patch "/comments/#{comment.id}.json", params: {} }

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns errors' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
    end
  end

  describe 'DELETE /comments/:id.json' do
    context 'when the specified comment exists' do
      let!(:comment) { create(:comment) }

      it 'returns 204 No Content' do
        delete "/comments/#{comment.id}.json"
        expect(response.status).to eq 204
      end

      it 'destroy the comment' do
        expect {
          delete "/comments/#{comment.id}.json"
        }.to change(Comment, :count).by(-1)
      end
    end

    context 'when the specified comment does not exist' do
      before { delete '/comments/1.json' }

      include_examples 'The resource is not found'
    end
  end
end
