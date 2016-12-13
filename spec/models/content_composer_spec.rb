RSpec.describe ContentComposer do
  let(:locale) { 'en' }
  subject      { described_class.new(locale, content) }

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

   describe '#post_processors' do
     it 'returns TableWrapper, TableCaptioner, ExternalLink and InternalLink' do
       expect(subject.post_processors).to match_array [TableWrapper, TableCaptioner, ExternalLink, InternalLink, ImgSrcset]
     end
   end

  end
end
