RSpec.describe LinkableObject do
  subject(:linkable_object) { LinkableObject.new(url, link_type: link_type) }
  let(:url) { 'some/url' }

  describe '#valid?' do
    context 'when link type page' do
      let(:link_type) { 'page' }

      it 'returns true' do
        expect(linkable_object).to be_valid
      end
    end

    context 'when link type file' do
      let(:link_type) { 'file' }

      it 'returns true' do
        expect(linkable_object).to be_valid
      end
    end

    context 'when link type snippet' do
      let(:link_type) { 'snippet' }

      it 'returns false' do
        expect(linkable_object).to_not be_valid
      end
    end
  end

  describe '.find' do
    subject { described_class.find(url, link_type: link_type) }

    context 'when link type page' do
      let(:page) { build(:page) }
      let(:link_type) { 'page' }

      it 'find the page by the slug' do
        expect(Comfy::Cms::Page).to receive(:find_by).with(slug: url).and_return(page)
        expect(subject).to eq(page)
      end
    end

    context 'when link type file' do
      let(:file) { build(:file) }
      let(:link_type) { 'file' }

      it 'find the file by the file name' do
        expect(Comfy::Cms::File).to receive(:find_by).with(file_file_name: url).and_return(file)
        expect(subject).to eq(file)
      end
    end

    context 'when another link type' do
      let(:link_type) { 'inexistent-link-type' }

      it 'returns false' do
        expect(subject).to be_nil
      end
    end
  end
end