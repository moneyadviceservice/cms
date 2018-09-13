describe ComfortableMexicanSofa::Tag::RequiredField do
  describe '.regex_tag_signature' do
    subject { tag_signature.match(described_class.regex_tag_signature('test')) }

    context 'when a required field tag' do
      let (:tag_signature) { '{{ cms:page:test:required }}' }

      it 'matches' do
        expect(subject).to be_truthy
      end
    end

    context 'when not a required field tag' do
      let (:tag_signature) { '{{ cms:page:test:string }}' }

      it 'does not match' do
        expect(subject).to be_falsey
      end
    end
  end
end
