require 'rails_helper'

RSpec.describe 'Star API', type: :request do
  describe 'GET /snippets/:snippet_id/star.json' do
    let(:user) { create(:user) }
    let(:snippet) { create(:snippet) }

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

  describe 'PUT /snippets/:snippet_id/star.json' do
    let(:user) { create(:user) }
    let(:snippet) { create(:snippet) }

    it 'returns 204 No Content' do
      put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      expect(response.status).to eq 204
    end

    it 'stars the snippet by the user' do
      expect {
        put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      }.to change(Star, :count).by(1)
    end

    it 'binds the user and the snippet' do
      put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      expect(user.starred_snippets).to eq [snippet]
      expect(snippet.starring_users).to eq [user]
    end

    it 'does not star the snippet multiple times by the same user' do
      put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      expect {
        put "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      }.not_to change(Star, :count)
    end
  end

  describe 'DELETE /snippets/:snippet_id/star.json' do
    let(:user) { create(:user) }
    let(:snippet) { create(:snippet) }

    before { user.starred_snippets << snippet }

    it 'returns 204 No Content' do
      delete "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      expect(response.status).to eq 204
    end

    it 'unstars the snippet by the user' do
      expect {
        delete "/snippets/#{snippet.id}/star.json", params: { user_id: user.id }
      }.to change(Star, :count).by(-1)
    end
  end
end
