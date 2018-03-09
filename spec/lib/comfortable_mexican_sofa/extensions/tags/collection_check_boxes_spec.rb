describe ComfortableMexicanSofa::Tag::CollectionCheckBoxes do
  describe '::regex_tag_signature' do
    subject { tag_signature.match(described_class.regex_tag_signature('test')) }

    context 'when a collection_check_boxes tag' do
      let (:tag_signature) { '{{ cms:page:test:collection_check_boxes/param1, param2 }}' }
      it 'matches' do
        expect(subject).to be_truthy
      end
    end

    context 'when not an collection_check_boxes tag' do
      let (:tag_signature) { '{{ cms:page:test:string }}' }
      it 'does not match' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#collection_params' do
    let (:tag) { described_class.initialize_tag(nil, tag_signature) }
    subject { tag.collection_params }

    context 'when valid arguments' do
      let (:tag_signature) { '{{ cms:page:test:collection_check_boxes/param1, param2 }}' }

      it 'returns array of params' do
        expect(subject).to eq ['param1', 'param2']
      end
    end
  end
end
