describe DbLinkSerializer do
  let(:attributes) do
    { text: 'some link', url: 'http://www.example.com', locale: 'en' }
  end

  subject { described_class.new(Link.new(attributes)) }

  it 'returns attributes' do
    expect(subject.as_json[:text]).to eql(attributes[:text])
    expect(subject.as_json[:url]).to eql(attributes[:url])
    expect(subject.as_json[:locale]).to eql(attributes[:locale])
  end
end
