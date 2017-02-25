require 'rails_helper'

RSpec.describe 'Star API', type: :request do
  describe 'GET /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the specified snippet exists' do
      context 'when the user has already starred the snippet' do
        before { user.starred_snippets << snippet }

        it 'returns 204 No Content' do
          get "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
          expect(response.status).to eq 204
        end
      end

      context 'when the user has not starred the snippet' do
        it 'returns 404 Not Found' do
          get "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
          expect(response.status).to eq 404
        end
      end
    end

    context 'when the specified snippet does not exist' do
      before { get "/snippets/#{Snippet.last.id.succ}/star.json", params: { user_id: user.id }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end

    context 'when the specified user does not exist' do
      before { get "/snippets/#{snippet.id}/star.json", params: { user_id: User.last.id.succ }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end
  end

  describe 'PUT /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the specified snippet exists' do
      it 'returns 204 No Content' do
        put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        expect(response.status).to eq 204
      end

      it 'stars the snippet by the user' do
        expect {
          put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        }.to change(Star, :count).by(1)
      end

      it 'binds the user and the snippet' do
        put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        expect(user.starred_snippets).to eq [snippet]
        expect(snippet.starring_users).to eq [user]
      end

      it 'does not star the snippet multiple times by the same user' do
        put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        expect {
          put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        }.not_to change(Star, :count)
      end

      context 'when other user sends the request' do
        let(:other_user) { create(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified snippet does not exist' do
      before { get "/snippets/#{Snippet.last.id.succ}/star.json", params: { user_id: user.id }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end

    context 'when the specified user does not exist' do
      before { get "/snippets/#{snippet.id}/star.json", params: { user_id: User.last.id.succ }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end
  end

  describe 'DELETE /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the specified snippet exists' do
      before { user.starred_snippets << snippet }

      it 'returns 204 No Content' do
        delete "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        expect(response.status).to eq 204
      end

      it 'unstars the snippet by the user' do
        expect {
          delete "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
        }.to change(Star, :count).by(-1)
      end

      context 'when other user sends the request' do
        let(:other_user) { create(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          delete "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specified snippet does not exist' do
      before { get "/snippets/#{Snippet.last.id.succ}/star.json", params: { user_id: user.id }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end

    context 'when the specified user does not exist' do
      before { get "/snippets/#{snippet.id}/star.json", params: { user_id: User.last.id.succ }, headers: authenticated_header }

      include_examples 'The resource is not found'
    end
  end
end
