describe '#highlighted_terms' do
  class TestHelper
    include ActionView::Helpers
    include Cms::ViewMethods::Helpers
  end

  subject { TestHelper.new }

  describe '#highlighted_terms' do
    let(:content) { 'Some Words' }

    context 'when has content' do
      it 'returns the original content when no term is provided' do
        expect(subject.highlighted_terms(content)).to eq(content)
      end

      it 'highlights the matching terms' do
        expect(subject.highlighted_terms(content, 'word')).to eq('Some <b>Words</b>')
      end

      it 'does not highlight non matching terms' do
        expect(subject.highlighted_terms(content, 'no match')).to eq(content)
      end
    end

    context 'content is nil' do
      let(:content) { nil }
      it 'returns an empty string' do
        expect(subject.highlighted_terms(content, 'word')).to eq('')
      end
    end
  end
end
