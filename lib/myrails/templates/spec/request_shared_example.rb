shared_examples 'returns content as json' do
  before {action}

  it 'sends content as json' do
    expect(response.content_type).to eq("application/json")
  end
end
