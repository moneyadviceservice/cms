RSpec.describe Indexers::Adapter::Algolia do
  subject(:algolia_adapter) { described_class.new(index_name: index_name) }

  describe '#create_or_update' do
    let(:index_name) { 'pages' }
    let(:objects) { [1, 2, 3, 4, 5] }
    let(:algolia_index) { double('Algolia::Index') }

    it 'index objects' do
      expect(::Algolia::Index).to receive(:new)
        .with('pages').and_return(algolia_index)
      expect(algolia_index).to receive(:add_objects).with(objects)
      algolia_adapter.create_or_update(objects)
    end
  end
end
