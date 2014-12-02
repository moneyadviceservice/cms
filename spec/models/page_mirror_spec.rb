RSpec.describe PageMirror do
  let(:page_mirror) { described_class.new(page) }

  let(:english_site) { create(:site, label: 'en', path: 'en') }
  let(:welsh_site) { create(:site, label: 'cy', path: 'cy') }

  let!(:page) do
    create(:page, label: 'Before borrow money', site: english_site)
  end

  let!(:welsh_page) do
    create(:page, label: 'Cyn i chi fenthyca arian', site: welsh_site)
  end

  let(:mirrors) { [welsh_page] }

  before do
    allow(page).to receive(:mirrors).and_return(mirrors)
  end

  describe '#mirror' do
    let(:mirror) { page_mirror.mirror(language) }

    context 'when english' do
      let(:language) { :en }

      it 'returns english label' do
        expect(mirror).to be(page)
      end
    end

    context 'when welsh' do
      let(:language) { :cy }

      it 'returns welsh label' do
        expect(mirror).to be(welsh_page)
      end
    end

    context 'when page not have mirrors' do
      let(:language) { :cy }
      let(:mirrors) { [] }

      it 'returns nil' do
        expect(mirror).to be_nil
      end
    end
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

    context 'when page not have mirrors' do
      let(:language) { :cy }
      let(:mirrors) { [] }

      it 'returns nil' do
        expect(label).to be_nil
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

    context 'when page not have mirrors' do
      let(:language) { :cy }
      let(:mirrors) { [] }

      it 'returns nil' do
        expect(url).to be_nil
      end
    end
  end
end

