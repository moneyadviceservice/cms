describe Cms::HippoImporter::Base do
  let(:xml) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }
  let(:docs) { ['do-you-need-to-borrow-money'] }

  let(:body) { File.read(Rails.root.join('spec', 'fixtures', 'example_body.txt')) }
  let(:parsed) { described_class.new(data: xml, docs: docs).import! }

  subject { parsed.first }

  it 'imports the articles in the xml' do
    expect(parsed.count).to eql(1)

    expect(subject.label).to eql('Do you need to borrow money?')
    expect(subject.slug).to eql('do-you-need-to-borrow-money')
    expect(subject.created_at.utc.to_s).to eql('2012-05-31 10:14:35 UTC')
    expect(subject.updated_at.utc.to_s).to eql('2014-05-27 11:16:32 UTC')
    expect(subject.state).to eql('draft')
    content = subject.blocks.first
    expect(content.identifier).to eql('content')
    expect(content.content).to eql(body)
  end

end
