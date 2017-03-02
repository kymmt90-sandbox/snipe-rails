RSpec.shared_examples 'The resource is not found' do
  it 'returns an error' do
    expect(response.status).to eq 404

    expected_json = {
      errors: [
        String
      ]
    }
    expect(response.body).to be_json_as expected_json

    json = JSON.parse(response.body)
    expect(json['errors'].first).to match /not found\Z/
  end
end

RSpec.shared_examples 'Required parameters are missing' do
  it 'returns an error' do
    expect(response.status).to eq 400

    expected_json = {
      errors: [
        'Required parameters are missing'
      ]
    }
    expect(response.body).to be_json_as expected_json
  end
end
