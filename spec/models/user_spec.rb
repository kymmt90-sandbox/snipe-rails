require 'rails_helper'

RSpec.describe User, type: :model do
  context 'a built user' do
    it 'is valid' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid when its name is empty' do
      user = build(:user, name: '')
      expect(user).not_to be_valid
    end

    it 'is invalid when its email is empty' do
      user = build(:user, email: '')
      expect(user).not_to be_valid
    end

    it 'is invalid when its email is not unique' do
      user = create(:user)
      another_user = build(:user, email: user.email)
      expect(another_user).not_to be_valid
    end

    it 'is invalid when its password is empty' do
      user = build(:user, password: '')
      expect(user).not_to be_valid
    end

    context 'user with comments' do
      let(:user) { create(:user_with_comments) }

      it 'is valid' do
        expect(user).to be_valid
      end

      it 'has multiple comments' do
        expect(user.comments.size).to eq 5
      end
    end

    context 'user with starring snippets' do
      let(:user) { create(:user_with_starred_snippets) }

      it 'is valid' do
        expect(user).to be_valid
      end

      it 'has multiple starred snippets' do
        expect(user.starred_snippets.size).to eq 5
      end
    end
  end
end
