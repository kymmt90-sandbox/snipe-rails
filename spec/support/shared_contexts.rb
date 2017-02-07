RSpec.shared_context 'the user has the authentication token' do
  let!(:user) { create(:user) }
  let!(:authenticated_header) { authentication_token_header(user) }
end
