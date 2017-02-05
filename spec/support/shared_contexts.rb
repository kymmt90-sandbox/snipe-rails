RSpec.shared_context 'the user has the authentication token' do
  let!(:user) { create(:user) }
  let!(:authenticated_header) do
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { 'Authorization': "Bearer #{token}" }
  end
end
