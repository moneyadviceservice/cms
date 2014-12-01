RSpec.describe PageMirror do
  let(:page_mirror) { described_class.new(page) }

  let!(:welsh_site) do
   create(:site, is_mirrored: true, path: 'cy', label: 'cy')
  end

  let!(:site) do
    create(:site, is_mirrored: true, path: 'en', label: 'en')
  end

  let(:page) do
    create(:page, label: 'Before borrow money', site: site)
  end

  let!(:welsh_page) do
    create(:page, site: welsh_site, label: 'Cyn i chi fenthyca arian')
  end

  describe '#label' do
    subject(:label) { page_mirror.label(language) }

    context 'when english' do
      let(:language) { :en }

      it 'returns english label' do
        expect(label).to eq('Before borrow money')
      end
    end

    context 'when welsh' do
      let(:language) { :cy }

      it 'returns welsh label' do
        expect(label).to eq('Cyn i chi fenthyca arian')
      end
    end
  end

  describe '#url' do
    subject(:url) { page_mirror.url(language) }

    context 'when english' do
      let(:language) { :en }

      it 'returns english url' do
        expect(url).to eq('//test.host/en/')
      end
    end

    context 'when welsh' do
      let(:language) { :cy }

      it 'returns welsh url' do
        expect(url).to eq('//test.host/cy/')
      end
    end
  end
end

