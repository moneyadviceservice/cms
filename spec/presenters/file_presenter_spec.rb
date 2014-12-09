RSpec.describe FilePresenter do
  subject(:presenter) { described_class.new(file) }
  let(:file) { build(:file) }

  describe '#full_path' do
    let(:site) { build(:site, hostname: 'localhost:3000') }
    let(:file) { double(site: site, file: double(url: 'foo-bar')) }

    it 'returns the site hostname with the file url' do
      expect(presenter.full_path).to eq('http://localhost:3000/foo-bar')
    end
  end

  describe '#url_scheme' do
    context 'development environment' do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
      end

      it 'returns "http"' do
        expect(presenter.url_scheme).to eq('http')
      end
    end

    context 'production environment' do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it 'returns "https"' do
        expect(presenter.url_scheme).to eq('https')
      end
    end
  end
end
