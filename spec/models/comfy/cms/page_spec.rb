RSpec.describe Comfy::Cms::Page do
  describe '.find_by_url' do
    context 'when page' do
      let!(:page) { create(:page, site: site, slug: 'investing-money') }
      let(:site) { create(:site, path: 'en') }

      context 'when site has path' do
        it 'returns page' do
          expect(described_class.find_by_url('/en/investing-money')).to eq(page)
        end
      end

      context 'when site does not have path' do
        let(:site) { create(:site, path: nil) }

        it 'returns page' do
          expect(described_class.find_by_url('/investing-money')).to eq(page)
        end
      end

      context 'when url has the "articles" word between path and slug' do
        it 'returns page' do
          expect(described_class.find_by_url('/en/articles/investing-money')).to eq(page)
        end
      end

      context 'when url has the site path included in the slug' do
        let!(:page) { create(:page, site: site, slug: 'investing-money-en') }

        it 'returns page' do
          expect(described_class.find_by_url('/en/articles/investing-money-en')).to eq(page)
        end
      end
    end

    context 'when file' do
      let(:url) { 'system/file.pdf' }

      it 'returns nil' do
        expect(described_class.find_by_url(url)).to be_nil
      end
    end

    context 'when external url' do
      let(:url) { 'http://moneysite.com/' }

      it 'returns nil' do
        expect(described_class.find_by_url(url)).to be_nil
      end
    end
  end
end
