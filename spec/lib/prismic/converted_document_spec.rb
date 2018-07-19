RSpec.describe Prismic::ConvertedDocument do
  subject(:converted_document) do
    described_class.new(attributes)
  end

  describe '#formatted_title' do
    let(:attributes) do
      { title: '<h1>Some title</h1>' }
    end

    it 'strips tags' do
      expect(converted_document.formatted_title).to eq('Some title')
    end
  end

  describe '#filename' do
    context 'when title is present' do
      let(:attributes) do
        { title: '<h1>Some title</h1>' }
      end

      it 'returns title paramterized' do
        expect(converted_document.filename).to eq('some-title')
      end
    end

    context 'when document does not have title' do
      let(:attributes) { {} }

      it 'returns empty string' do
        expect(converted_document.filename).to eq('')
      end
    end
  end
end
