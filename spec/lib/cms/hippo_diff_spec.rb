RSpec.describe Cms::HippoDiff do
  let(:data) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }
  subject(:hippo_diff) { described_class.new(data: data) }

  describe '#collection' do
    subject(:collection) { hippo_diff.collection }
    let(:partners) { double(id: 'partners') }
    let(:debt) { double(id: 'debt') }
    let(:about_us) { double(id: 'about-us') }
    let(:media_centre) { double(id: 'media-centre') }

    let(:hippo_pages) do
      [partners, debt, about_us, media_centre]
    end

    let(:contento_slugs) do
      %w(
        partners
        debt
      )
    end

    before do
      expect(hippo_diff).to receive(:hippo_pages).and_return(hippo_pages)
      expect(hippo_diff).to receive(:contento_slugs).at_least(:once).and_return(contento_slugs)
    end

    it 'returns the difference between hippo slugs and contento slugs' do
      expect(collection).to eq([about_us, media_centre])
    end
  end

  describe '#hippo_pages' do
    let(:record) { double(id: 'do-you-need-to-borrow-money') }

    before do
      expect(hippo_diff.parser).to receive(:parse).and_return([record])
    end

    it 'returns slugs from content file' do
      expect(hippo_diff.hippo_pages).to eq([Cms::HippoPage.new(record)])
    end
  end

  describe '#contento_slugs' do
    let!(:page) { create(:page, slug: 'about-us') }

    it 'returns all slugs from the CMS' do
      expect(hippo_diff.contento_slugs).to eq(['about-us'])
    end
  end
end
