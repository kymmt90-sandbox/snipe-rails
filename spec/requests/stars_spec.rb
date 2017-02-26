require 'rails_helper'

RSpec.describe 'Star API', type: :request do
  describe 'GET /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the authenticated header does not exist' do
      it 'return 401 Unauthorized' do
        get "/snippets/#{snippet.id}/star.json"
        expect(response.status).to eq 401
      end
    end

    context 'when the specified snippet exists' do
      context 'when the user has already starred the snippet' do
        before do
          user.starred_snippets << snippet
          get "/snippets/#{snippet.id}/star.json", headers: authenticated_header
        end

        it 'returns 204 No Content' do
          expect(response.status).to eq 204
        end
      end

      context 'when the user has not starred the snippet' do
        it 'returns 404 Not Found' do
          get "/snippets/#{snippet.id}/star.json", headers: authenticated_header
          expect(response.status).to eq 404
        end
      end
    end

    context 'when the specified snippet does not exist' do
      before do
        get "/snippets/#{Snippet.last.id.succ}/star.json", headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'PUT /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the authenticated header does not exist' do
      it 'return 401 Unauthorized' do
        put "/snippets/#{snippet.id}/star.json"
        expect(response.status).to eq 401
      end
    end

    context 'when the specified snippet exists' do
      it 'stars the snippet by the user and does not star it multiple times by the same user' do
        expect {
          put "/snippets/#{snippet.id}/star.json", headers: authenticated_header
        }.to change(Star, :count).by 1

        put "/snippets/#{snippet.id}/star.json", headers: authenticated_header
        expect {
          put "/snippets/#{snippet.id}/star.json", headers: authenticated_header
        }.not_to change(Star, :count)
      end

      it 'binds the user and the snippet' do
        put "/snippets/#{snippet.id}/star.json", headers: authenticated_header

        expect(response.status).to eq 204

        expect(user.starred_snippets).to eq [snippet]
        expect(snippet.starring_users).to eq [user]
      end
    end

    context 'when the specified snippet does not exist' do
      before do
        get "/snippets/#{Snippet.last.id.succ}/star.json", headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'DELETE /snippets/:snippet_id/star.json' do
    include_context 'the user has the authentication token'

    let!(:snippet) { create(:snippet) }

    context 'when the authenticated header does not exist' do
      it 'return 401 Unauthorized' do
        delete "/snippets/#{snippet.id}/star.json"
        expect(response.status).to eq 401
      end
    end

    context 'when the specified snippet exists' do
      before do
        user.starred_snippets << snippet
      end

      it 'unstars the snippet by the user' do
        expect {
          delete "/snippets/#{snippet.id}/star.json", headers: authenticated_header
        }.to change(Star, :count).by -1

        expect(response.status).to eq 204
      end
    end
  end
end
