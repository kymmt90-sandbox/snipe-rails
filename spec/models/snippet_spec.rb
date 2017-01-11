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
  end
end
