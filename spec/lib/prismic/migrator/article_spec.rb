RSpec.describe Prismic::Migrator::Article do
  subject(:article) { described_class.new(document)  }

  describe '#migrate' do
    subject(:migrated_page) { article.migrate }
    let!(:site) { create(:site, label: 'en') }
    let!(:layout) { create(:layout, identifier: 'article', site: site) }

    context 'when document has all fields for content' do
      let(:document) do
        Prismic::ConvertedDocument.new(
          title: '<h1>Media: CMA retail banking market investigation</h1>',
          content: 'some content',
          content_markdown: 'some content in markdown'
        )
      end

      it 'persisted to database' do
        expect(migrated_page).to be_persisted
      end

      it 'persists content' do
        block = migrated_page.blocks.find_by(identifier: 'content')
        expect(block).to_not be_nil
        expect(block.identifier).to eq('content')
        expect(block.processed_content).to eq('some content')
        expect(block.content).to eq('some content in markdown')
      end

      it 'persists other blocks' do
        blocks = migrated_page.blocks.where.not(identifier: 'content')
        expect(blocks[0].identifier).to eq('component_hero_description')
        expect(blocks[0].processed_content).to eq(
          'Media: CMA retail banking market investigation'
        )
      end
    end
  end
end
