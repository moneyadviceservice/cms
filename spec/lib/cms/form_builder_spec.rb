describe Cms::FormBuilder do
  subject do
    described_class.new(:model, Object.new, ActionView::Base.new, {})
  end

  describe '#page_image' do
    let(:page) { Comfy::Cms::Page.new }
    let(:tag) do
      ComfortableMexicanSofa::Tag::PageImage.new.tap do |pi|
        pi.blockable = page
        pi.identifier = 'hero_image'
      end
    end

    it 'adds label' do
      expect(subject.page_image(tag, 0)).to match(/label.*Hero image.*label/)
    end

    it 'adds text input' do
      expect(subject.page_image(tag, 0)).to match(/input.*text/)
    end

    it 'adds hidden input' do
      expect(subject.page_image(tag, 0)).to match(/input.*hidden/)
    end

    it 'adds previewer' do
      expect(subject.page_image(tag, 0)).to match(/div.*preview.*div/)
    end

    it 'adds insert button' do
      expect(subject.page_image(tag, 0)).to match(/button.*insert-image.*button/)
    end

    it 'adds remove button' do
      expect(subject.page_image(tag, 0)).to match(/button.*Remove.*button/)
    end
  end
end
