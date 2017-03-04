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
end
