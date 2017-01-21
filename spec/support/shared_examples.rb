RSpec.shared_examples 'The resource is not found' do
  it 'returns 404 Not Found' do
    expect(response.status).to eq 404
  end

  it 'returns an error message' do
    expect(response.body).to be_json_as(
                               {
                                 error: String
                               })
  end
end
