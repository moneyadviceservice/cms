RSpec.describe Indexers::Page do
  it_behaves_like 'an indexer', 'pages'

  subject(:page_indexer) do
    described_class.new(collection: collection, adapter: adapter)
  end

  let(:adapter) { 'local' }

  describe '#objects' do
    let(:collection) do
      [
        create(:page,
               label: 'Financial well being',
               slug: 'financial-well-being',
               meta_description: 'description',
               published_at: Time.zone.today,
               layout: create(:layout, :article)
              )
      ]
    end

    it 'returns objects to index' do
      expect(subject.objects).to eq([
        {
          objectID: '/en/articles/financial-well-being',
          title: 'Financial well being',
          description: 'description',
          published_at: Time.zone.today
        }
      ])
    end
  end
end
