require 'rails_helper'

RSpec.describe 'User API', type: :request do
  describe 'GET /users/:id.json' do
    context 'when the specified user exists' do
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

    context 'when parameters are invalid' do
      let(:invalid_user_attributes) { { user: { name: '', email: 'foo@example.com', password: 'passw0rd' } } }

      before do
        post '/users.json', params: invalid_user_attributes
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns error messages' do
        expect(response.body).to be_json_as(
                                   {
                                     name: ["can't be blank"]
                                   }
                                 )
      end
    end

    context 'when paramters are empty' do
      before do
        post '/users.json', params: {}
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns error messages' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
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

      it 'returns 200 OK' do
        patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header
        expect(response.status).to eq 200
      end

      it 'returns the updated user attributes' do
        patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header
        expect(response.body).to be_json_as(
                                   {
                                     id:   user.id,
                                     name: attributes_for_update[:user][:name]
                                   })
      end

      context 'when other user sends the request' do
        let(:other_user) { create(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header
          expect(response.status).to eq 401
        end

        it 'returns an empty JSON' do
          patch "/users/#{user.id}.json", params: attributes_for_update, headers: authenticated_header
          expect(response.body).to be_json_as({})
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
      let(:invalid_user_attributes) { { user: { name: '', email: 'foo@example.com', password: 'passw0rd' } } }

      before do
        patch "/users/#{user.id}.json", params: invalid_user_attributes, headers: authenticated_header
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns error messages' do
        expect(response.body).to be_json_as(
                                   {
                                     name: ["can't be blank"]
                                   }
                                 )
      end
    end

    context 'when paramters are empty' do
      before do
        patch "/users/#{user.id}.json", params: {}, headers: authenticated_header
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq 400
      end

      it 'returns error messages' do
        expect(response.body).to be_json_as(
                                   {
                                     error: String
                                   }
                                 )
      end
    end
  end

  describe 'DELETE /users/:id' do
    include_context 'the user has the authentication token'

    context 'when the specified user exists' do
      it 'returns 204 No Content' do
        delete "/users/#{user.id}.json", headers: authenticated_header
        expect(response.status).to eq 204
      end

      it 'destroys the user' do
        expect {
          delete "/users/#{user.id}.json", headers: authenticated_header
        }.to change(User, :count).by(-1)
      end

      context 'when other user sends the request' do
        let(:other_user) { create(:user) }
        let(:authenticated_header) { authentication_token_header(other_user) }

        it 'returns 401 Unauthorized' do
          delete "/users/#{user.id}.json", headers: authenticated_header
          expect(response.status).to eq 401
        end

        it 'returns an empty JSON' do
          delete "/users/#{user.id}.json", headers: authenticated_header
          expect(response.body).to be_json_as({})
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
