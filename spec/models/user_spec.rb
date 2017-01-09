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
  end
end
