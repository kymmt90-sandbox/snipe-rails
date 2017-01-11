require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  describe 'GET /snippets/:snippet_id/comments.json' do
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

  describe 'GET /comments/:id.json' do
    let(:comment) { create(:comment) }
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

  describe 'PATCH /comments/:id.json' do
    let(:comment) { create(:comment) }
    let(:comment_params) {
      {
        comment: {
          content: 'Modfied Comment'
        }
      }
    }

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

  describe 'DELETE /comments/:id.json' do
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
end
