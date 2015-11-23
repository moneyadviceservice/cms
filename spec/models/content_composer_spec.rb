RSpec.describe ContentComposer do
  subject { described_class.new(content) }

  let(:content) do
    'Content Block'
  end

  describe '#to_s' do
    it 'returns the content' do
      expect(subject.to_s).to eql(content)
    end
  end

  describe '#to_html' do
    context 'content provided' do
      it 'returns a composed html string' do
        expect(subject.to_html).to eql("<p>Content Block</p>\n")
      end
    end

    context 'no content provided' do
      let(:content) { '' }

      it 'is an empty string' do
        expect(subject.to_html).to eql("\n")
      end
    end

    context 'no content provided' do
      let(:content) { nil }

      it 'is an empty string' do
        expect(subject.to_html).to eql("\n")
      end
    end

    context 'post processing' do
      let(:content) do
        '<table></table>'
      end

      it 'returns a composed html string' do
        expect(subject.to_html).to eql("<div class=\"table-wrapper\"><table></table></div>\n")
      end
    end
  end
end
