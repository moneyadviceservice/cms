describe ComfortableMexicanSofa::Tag::PageImage do
  describe '::regex_tag_signature' do
    context 'when an image tag' do
      it 'matches' do
        expect('{{ cms:page:test:image }}'.match(described_class.regex_tag_signature('test'))).to be_truthy
      end
    end

    context 'when not an image tag' do
      it 'does not match' do
        expect('{{ cms:page:test:string }}'.match(described_class.regex_tag_signature('test'))).to be_falsey
      end
    end
  end
end
