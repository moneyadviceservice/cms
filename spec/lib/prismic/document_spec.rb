RSpec.describe Prismic::Document do
  subject(:document) do
    described_class.new(
      title: 'title',
      content: 'some content'
    )
  end

  describe '#row' do
    it 'returns data from args' do
      expect(document.row).to eq(
        title: 'title',
        content: 'some content'
      )
    end
  end

  describe '#attributes' do
    subject(:attributes) do
      document.attributes
    end

    it 'returns attribute names from args' do
      expect(attributes).to match_array([:title, :content])
    end
  end
end
