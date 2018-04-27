RSpec.describe Indexers::Page do
  it_behaves_like 'an indexer', 'pages'

  subject(:page_indexer) do
    described_class.new(collection: collection, adapter: adapter)
  end

  let(:adapter) { 'local' }

  describe '#objects' do
    context 'when title, description and keywords are present' do
      let(:collection) do
        [
          create(:page,
                 label: 'Financial well being',
                 slug: 'financial-well-being',
                 meta_description: 'meta description',
                 meta_keywords: 'financial, well-being',
                 published_at: Time.zone.today,
                 layout: create(:layout, :article),
                 blocks: [
                   create(:block, processed_content: '<p>some content</p>')
                 ]
                )
        ]
      end

      it 'index pages with all attributes' do
        expect(subject.objects).to eq(
          [
            {
              objectID: '/en/articles/financial-well-being',
              title: 'Financial well being',
              description: 'meta description',
              keywords: ['financial', 'well-being'],
              content: '<p>some content</p>',
              published_at: Time.zone.today
            }
          ]
        )
      end
    end

    context 'when keywords are not present' do
      let(:collection) do
        [
          create(:page,
                 label: 'Financial well being',
                 slug: 'financial-well-being',
                 meta_description: 'meta description',
                 published_at: Time.zone.today,
                 layout: create(:layout, :article),
                 blocks: [
                   create(:block, processed_content: '<p>some content</p>')
                 ]
                )
        ]
      end

      it 'index pages with empty keywords' do
        expect(subject.objects).to eq(
          [
            {
              objectID: '/en/articles/financial-well-being',
              title: 'Financial well being',
              description: 'meta description',
              keywords: [],
              content: '<p>some content</p>',
              published_at: Time.zone.today
            }
          ]
        )
      end
    end
  end
end
