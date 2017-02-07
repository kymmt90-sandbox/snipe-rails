module TestHelper
  def authentication_token_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { 'Authorization': "Bearer #{token}" }
  end
end
