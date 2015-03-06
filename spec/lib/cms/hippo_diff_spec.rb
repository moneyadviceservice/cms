RSpec.describe Cms::HippoDiff do
  let(:data) { File.read(Rails.root.join('spec', 'fixtures', 'example.xml')) }
  subject(:hippo_diff) { described_class.new(data: data) }

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
