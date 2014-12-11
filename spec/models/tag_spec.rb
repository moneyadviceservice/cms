describe Tag do
  context 'taggings' do
    subject(:tag) { Tag.create!(value: 'test') }

    context 'without taggings' do
      it 'has no taggings' do
        expect(subject.taggings_size).to eq(0)
      end

      it 'is not in use' do
        expect(subject).to_not be_in_use
      end
    end

    context 'with taggings' do
      before { Tagging.create!(tag: tag, taggable_type: 'test', taggable_id: 1) }

      it 'return count of taggings that use the tag' do
        expect(subject.taggings_size).to eq(1)
      end

      it 'is in use' do
        expect(subject).to be_in_use
      end
    end
  end
end
