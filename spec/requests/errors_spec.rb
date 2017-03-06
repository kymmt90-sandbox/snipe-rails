require 'rails_helper'

RSpec.describe 'Errors', type: :request do
  describe 'GET /users/:id.json' do
    context 'when an internal server error occurs' do
      before do
        allow(User).to receive(:find).and_raise('internal server error')
      end

      it 'returns 500 Internal Server Error' do
        get '/users/1.json'
        expect(response.status).to eq 500
      end
    end
  end

  describe 'GET *path.json' do
    context 'when specified URL does not exist' do
      it 'returns error messages' do
        get '/not_exist.json'

        expect(response.status).to eq 404

        expected_json = {
          errors: [
            String
          ]
        }
        expect(response.body).to be_json_as expected_json

        json = JSON.parse(response.body)
        expect(json['errors'].first).to match /does not exist\Z/
      end
    end
  end
end
