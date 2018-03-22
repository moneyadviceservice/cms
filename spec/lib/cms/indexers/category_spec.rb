RSpec.describe Indexers::Category do
  it_behaves_like 'an indexer', 'categories'

  subject(:category_indexer) do
    described_class.new(collection: collection, adapter: adapter)
  end

  let(:adapter) { 'local' }

  describe '#objects' do
    let(:collection) do
      [
        create(:category,
               label: 'work-and-redundancy',
               title_en: 'Work and redundancy',
               title_cy: 'Gwaith a diweithdra',
               description_en: 'Advice on understanding your employment rights',
               description_cy: 'Cyngor ar ddeall eich hawliau'
              )
      ]
    end

    it 'returns categories in welsh and english to index' do
      expect(subject.objects).to eq([
        {
          objectID: '/en/categories/work-and-redundancy',
          title: 'Work and redundancy',
          description: 'Advice on understanding your employment rights',
          links: []
        },
        {
          objectID: '/cy/categories/work-and-redundancy',
          title: 'Gwaith a diweithdra',
          description: 'Cyngor ar ddeall eich hawliau',
          links: []
        }
      ])
    end
  end
end
