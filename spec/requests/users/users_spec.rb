require 'rails_helper'

RSpec.describe 'User API', type: :request do
  describe 'GET /users/:id.json' do
    let(:user) { create(:user) }

    before do
      get "/users/#{user.id}.json"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
    end

    it 'returns the user attributes' do
      expect(response.body).to be_json_as(
                                 {
                                   id:   user.id,
                                   name: user.name
                                 })
    end
  end

  describe 'POST /users.json' do
    let(:user_attributes) { attributes_for(:user) }

    it 'returns 201 Created' do
      post '/users.json', params: { user: user_attributes }
      expect(response.status).to eq 201
    end

    it 'creates the user' do
      expect {
        post '/users.json', params: { user: user_attributes }
      }.to change(User, :count).by(1)
    end

    it 'returns the created user attributes' do
      post '/users.json', params: { user: user_attributes }
      expect(response.body).to be_json_as(
                                 {
                                   id:   Numeric,
                                   name: user_attributes[:name]
                                 })
    end
  end

  describe 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:attributes_for_update) {
      {
        user: {
          name:     'Jirō Yamada',
          email:    'jyamada@example.com',
          password: '5ecret'
        }
      }
    }

    before do
      patch "/users/#{user.id}.json", params: attributes_for_update
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
    end

    it 'returns the updated user attributes' do
      expect(response.body).to be_json_as(
                                 {
                                   id:   user.id,
                                   name: attributes_for_update[:user][:name]
                                 })
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { create(:user) }

    it 'returns 204 No Content' do
      delete "/users/#{user.id}.json"
      expect(response.status).to eq 204
    end

    it 'destroys the user' do
      expect {
        delete "/users/#{user.id}.json"
      }.to change(User, :count).by(-1)
    end
  end
end
