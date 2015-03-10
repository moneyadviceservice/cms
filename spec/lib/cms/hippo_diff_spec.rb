RSpec.describe Cms::HippoDiff do
  let(:data) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }
  subject(:hippo_diff) { described_class.new(data: data) }

  describe '#collection' do
    subject(:collection) { hippo_diff.collection }
    let(:slugs) do
      %w(
        partners
        debt
        about-us
        media-centre
      )
    end

    let(:contento_slugs) do
      %w(
        partners
        debt
      )
    end

    before do
      expect(hippo_diff).to receive(:slugs).and_return(slugs)
      expect(hippo_diff).to receive(:contento_slugs).and_return(contento_slugs)
    end

    it 'returns the difference between hippo slugs and contento slugs' do
      expect(collection).to eq(%w(about-us media-centre))
    end
  end

  describe '#slugs' do
    it 'returns slugs from content file' do
      expect(hippo_diff.slugs).to eq(['do-you-need-to-borrow-money'])
    end
  end

  describe '#contento_slugs' do
    let!(:page) { create(:page, slug: 'about-us') }

    it 'returns all slugs from the CMS' do
      expect(hippo_diff.contento_slugs).to eq(['about-us'])
    end
  end
end
