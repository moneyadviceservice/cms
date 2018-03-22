RSpec.shared_examples 'an indexer' do |parameter|
  let(:collection) { [1] }
  let(:adapter) { 'local' }

  subject do
    described_class.new(collection: collection, adapter: adapter)
  end

  describe '#index_name' do
    it 'returns index name' do
      expect(subject.index_name).to eq(parameter)
    end
  end

  describe '#index' do
    it 'responds to index' do
      expect(subject).to respond_to(:index)
    end

    it 'calls create or update from adapter' do
      allow(subject).to receive(:objects).and_return([1])
      expect(subject.adapter).to receive(:create_or_update).with([1])
      subject.index
    end
  end

  describe '#objects' do
    it 'responds to objects' do
      expect(subject).to respond_to(:objects)
    end
  end
end
