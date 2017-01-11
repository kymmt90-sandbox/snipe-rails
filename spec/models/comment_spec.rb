require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'built comment' do
    it 'is valid' do
      comment = build_stubbed(:comment)
      expect(comment).to be_valid
    end

    it 'is invalid when content is empty' do
      comment = build_stubbed(:comment, content: '')
      expect(comment).not_to be_valid
    end

    it 'is invalid when comment_author is empty' do
      comment = build_stubbed(:comment, comment_author: nil)
      expect(comment).not_to be_valid
    end

    it 'is invalid when snippet is empty' do
      comment = build_stubbed(:comment, snippet: nil)
      expect(comment).not_to be_valid
    end
  end
end
