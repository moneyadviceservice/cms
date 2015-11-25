class ImageTest
  include ComfortableMexicanSofa::Tag
end

class ObjectTest
  include ComfortableMexicanSofa::Tag
end

describe ComfortableMexicanSofa::Tag do
  describe '#is_cms_block?' do
    context 'when image' do
      subject { ImageTest.new }

      it 'returns true' do
        expect(subject.is_cms_block?).to be_truthy
      end
    end

    context 'when not an image' do
      subject { ObjectTest.new }

      it 'returns false' do
        expect(subject.is_cms_block?).to be_falsey
      end
    end
  end
end
