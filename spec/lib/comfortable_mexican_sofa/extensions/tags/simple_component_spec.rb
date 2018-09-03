describe ComfortableMexicanSofa::Tag::SimpleComponent do
  describe '.regex_tag_signature' do
    subject { tag_signature.match(described_class.regex_tag_signature('test')) }

    context 'when a simple component tag' do
      let(:tag_signature) { '{{ cms:page:test:simple_component/param1, param2 }}' }

      it 'matches' do
        expect(subject).to be_truthy
      end
    end

    context 'when not an simple component tag' do
      let(:tag_signature) { '{{ cms:page:test:string }}' }

      it 'does not match' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#identifier' do
    let(:tag) { described_class.initialize_tag(nil, tag_signature) }
    subject { tag.identifier }

    context 'when valid arguments' do
      let(:tag_signature) do
        '{{ cms:page:hero_image:simple_component//image.jpg }}'
      end

      it 'returns array of params' do
        expect(subject).to eq('component_hero_image')
      end
    end
  end
end
