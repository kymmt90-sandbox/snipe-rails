require 'rails_helper'

RSpec.describe Snippet, type: :model do
  context 'built snippet' do
    it 'is valid' do
      snippet = build_stubbed(:snippet)
      expect(snippet).to be_valid
    end

    it 'is invalid when content is empty' do
      snippet = build_stubbed(:snippet, content: '')
      expect(snippet).not_to be_valid
    end

    it 'is invalid when author is empty' do
      snippet = build_stubbed(:snippet, author: nil)
      expect(snippet).not_to be_valid
    end

    context 'snippet with comments' do
      let(:snippet) { create(:snippet_with_comments, comments_count: comments_count) }
      let(:comments_count) { 2 }

      it 'is valid' do
        expect(snippet).to be_valid
      end

      it 'has multiple comments' do
        expect(snippet.comments.size).to eq comments_count
      end
    end

    context 'snippet with starred users' do
      let(:snippet) { create(:snippet_with_starring_users, starring_users_count: starring_users_count) }
      let(:starring_users_count) { 2 }

      it 'is valid' do
        expect(snippet).to be_valid
      end

      it 'has multiple starring users' do
        expect(snippet.starring_users.size).to eq starring_users_count
      end
    end
  end
end
