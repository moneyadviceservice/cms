require 'spec_helper'
require_relative '../../lib/cms/hippo_import'

describe HippoImport do
  let(:xml) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }

  let(:body) { " ****\n\n## Before you sign up for a credit card\n bank loan or store card, or add to an existing card or loan it makes sense to think about whether you really need to borrow money. [Google](http://www.google.com){:target='_blank'}" }

  let(:parsed) { HippoImport.new(xml).import! }

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
