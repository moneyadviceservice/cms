RSpec.describe LinkableObject do
  let(:url) { 'some/url' }
  subject(:linkable_object) { LinkableObject.new(object, url) }

  describe '.find' do
    subject { described_class.find(url) }

    context 'when finds a page' do
      let(:page) { build(:page) }

      before do
        allow(described_class).to receive(:find_page).and_return(page)
      end

      it 'returns a page linkable object' do
        expect(subject.object).to be(page)
      end
    end

    context 'when finds a file' do
      let(:file) { build(:file) }

      before do
        allow(described_class).to receive(:find_file).and_return(file)
      end

      it 'returns a page linkable object' do
        expect(subject.object).to be(file)
      end
    end

    context 'when finds nothing' do
      it 'returns a nil linkable object' do
        expect(subject.object).to be_nil
      end
    end
  end

  describe '.find_page' do
    context 'when page' do
      let!(:page) { create(:page, site: site, slug: 'investing-money') }
      let(:site) { create(:site, path: 'en') }

      context 'when site has path' do
        it 'returns page' do
          expect(described_class.find_page('/en/investing-money')).to eq(page)
        end
      end

      context 'when site does not have path' do
        let(:site) { create(:site, path: nil) }

        it 'returns page' do
          expect(described_class.find_page('/investing-money')).to eq(page)
        end
      end

      context 'when url has the "articles" word between path and slug' do
        it 'returns page' do
          expect(described_class.find_page('/en/articles/investing-money')).to eq(page)
        end
      end

      context 'when url has the site path included in the slug' do
        let!(:page) { create(:page, site: site, slug: 'investing-money-en') }

        it 'returns page' do
          expect(described_class.find_page('/en/articles/investing-money-en')).to eq(page)
        end
      end
    end

    context 'when file' do
      let(:url) { 'system/file.pdf' }

      it 'returns nil' do
        expect(described_class.find_page(url)).to be_nil
      end
    end

    context 'when external url' do
      let(:url) { 'http://moneysite.com/' }

      it 'returns nil' do
        expect(described_class.find_page(url)).to be_nil
      end
    end
  end

  describe '#find_file' do
    before do
      expect(Comfy::Cms::File).to receive(:find_by).with(file_file_name: file_name).and_return(object)
    end

    context 'when file' do
      let(:object) { build(:file) }
      let(:file_name) { 'investing.pdf' }

      it 'returns file' do
        expect(described_class.find_file('/system/1/002/investing.pdf')).to eq(object)
      end
    end

    context 'when page' do
      let(:object) { nil }
      let(:file_name) { 'borrow-money' }

      it 'returns nil' do
        expect(described_class.find_file('en/borrow-money')).to be_nil
      end
    end

    context 'when external link' do
      let(:object) { nil }
      let(:file_name) { 'moneysite.com' }

      it 'returns nil' do
        expect(described_class.find_file(file_name)).to be_nil
      end
    end
  end

  describe '#label' do
    let(:object) { double(label: 'loan') }
    subject(:label) { linkable_object.label }

    context 'when is a page' do
      it 'returns the page label' do
        expect(label).to eq('loan')
      end
    end

    context 'when is a file' do
      it 'returns the file label' do
        expect(label).to eq('loan')
      end
    end

    context 'when is an external url' do
      let(:object) { nil }

      it 'returns the url' do
        expect(label).to eq('some/url')
      end
    end
  end

  describe '#type' do
    subject(:type) { linkable_object.type }

    context 'when is an external url' do
      let(:object) { nil }

      it 'returns "external"' do
        expect(type).to eq('external')
      end
    end

    context 'when is a page' do
      let(:object) { build(:page) }

      it 'returns "page"' do
        expect(type).to eq('page')
      end
    end

    context 'when is a file' do
      let(:object) { build(:file) }

      it 'returns "file"' do
        expect(type).to eq('file')
      end
    end
  end

  describe '#read_attribute_for_serialization' do
    subject(:object) { double(label: 'Loan') }

    it 'sends the value ' do
      expect(linkable_object.read_attribute_for_serialization('label')).to eq('Loan')
    end
  end
end
