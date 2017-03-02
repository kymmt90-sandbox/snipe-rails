require 'rails_helper'

RSpec.describe 'User API', type: :request do
  describe 'GET /users/:id.json' do
    context 'when the specified user exists' do
      let(:user) { create(:user) }

      it 'returns the user attributes' do
        get "/users/#{user.id}.json"

        expect(response.status).to eq 200

        expected_json = {
          id:   user.id,
          name: user.name
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when the specfied user does not exist' do
      before do
        get '/users/1.json'
      end

      include_examples 'The resource is not found'
    end
  end

  describe 'POST /users.json' do
    context 'when parameters is valid' do
      let(:user_attributes) { attributes_for(:user) }

      it 'creates the user and returns its attributes' do
        expect {
          post '/users.json', params: { user: user_attributes }
        }.to change(User, :count).by 1

        expect(response.status).to eq 201

        expected_json = {
          id:   Numeric,
          name: user_attributes[:name]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_user_attributes) {
        {
          user: {
            name:     '',
            email:    'foo@example.com',
            password: 'passw0rd'
          }
        }
      }

      it 'returns error messages' do
        post '/users.json', params: invalid_user_attributes

        expect(response.status).to eq 400

        expected_json = {
          name: ["can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when paramters are empty' do
      before do
        post '/users.json', params: {}
      end

      include_examples 'Required parameters are missing'
    end
  end

  describe 'PATCH /users/:id' do
    include_context 'the user has the authentication token'

    context 'when the specified user exists' do
      let(:attributes_for_update) {
        {
          user: {
            name:     'Jirō Yamada',
            email:    'jyamada@example.com',
            password: '5ecret'
          }
        }
      }

      it 'returns the updated user attributes' do
        patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header

        expect(response.status).to eq 200

        expected_json = {
          id:   user.id,
          name: attributes_for_update[:user][:name]
        }
        expect(response.body).to be_json_as expected_json
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specfied user does not exist' do
      before do
        patch "/users/#{User.last.id.succ}.json", params: {}, headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end

    context 'when parameters are invalid' do
      let(:invalid_user_attributes) {
        {
          user: {
            name:     '',
            email:    'foo@example.com',
            password: 'passw0rd'
          }
        }
      }

      it 'returns error messages' do
        patch "/users/#{user.id}.json", params: invalid_user_attributes, headers: authenticated_header

        expect(response.status).to eq 400

        expected_json = {
          name: ["can't be blank"]
        }
        expect(response.body).to be_json_as expected_json
      end
    end

    context 'when paramters are empty' do
      before do
        patch "/users/#{user.id}.json", params: {}, headers: authenticated_header
      end

      include_examples 'Required parameters are missing'
    end
  end

  describe 'DELETE /users/:id' do
    include_context 'the user has the authentication token'

    context 'when the specified user exists' do
      it 'destroys the user' do
        expect {
          delete "/users/#{user.id}.json", headers: authenticated_header
        }.to change(User, :count).by(-1)

        expect(response.status).to eq 204
      end

      context 'when other user sends the request' do
        let(:other_user) { build_stubbed(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          delete "/users/#{user.id}.json", headers: authenticated_header
          expect(response.status).to eq 401
        end
      end
    end

    context 'when the specfied user does not exist' do
      before do
        delete "/users/#{User.last.id.succ}.json", headers: authenticated_header
      end

      include_examples 'The resource is not found'
    end
  end
end
