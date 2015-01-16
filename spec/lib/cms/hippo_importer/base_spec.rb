describe Cms::HippoImporter::Base do
  let(:xml) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }
  let(:docs) { ['do-you-need-to-borrow-money'] }

  let(:importer) { described_class.new(data: xml, docs: docs) }

  let!(:site) { create(:site, :with_article_layout) }

  describe '#import!' do
    let(:imported) { importer.import! }
    subject(:article) { imported.first }
    let(:content) { article.blocks.first }
    let(:body) { File.read(Rails.root.join('spec', 'fixtures', 'example_body.txt')) }

    it 'imports the article label' do
      expect(article.label).to eql('Do you need to borrow money?')
    end

    it 'imports the article slug' do
      expect(article.slug).to eql('do-you-need-to-borrow-money')
    end

    it 'imports the article created_at' do
      expect(article.created_at.utc.to_s).to eql('2012-05-31 10:14:35 UTC')
    end

    it 'imports the article updated_at' do
      expect(article.updated_at.utc.to_s).to eql('2014-05-27 11:16:32 UTC')
    end

    it 'imports the same site passed in initialize' do
      expect(article.site).to eq(site)
    end

    it 'imports the article as "draft"' do
      expect(article.state).to eql('draft')
    end

    it 'imports content identifier' do
      expect(content.identifier).to eql('content')
    end

    it 'imports content body' do
      expect(content.content).to eql(body)
    end

    it 'import as an article as default' do
      expect(article.layout.identifier).to eq('article')
    end
  end
end
