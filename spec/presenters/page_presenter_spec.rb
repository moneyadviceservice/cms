RSpec.describe PagePresenter do
  subject(:presenter) do
    described_class.new(object)
  end

  describe '#last_update' do
    let(:object) { double(updated_at: Time.new(2014, 8, 1, 14, 45)) }

    it 'returns the author and the created at formated' do
      expect(presenter.last_update).to eq('01/08/2014, 14:45')
    end
  end

  describe '#preview_url' do
    let(:domain) { 'qa.contento.com' }
    let(:object) { double(site: double(label: 'en'), slug: 'investing') }

    before do
      allow(presenter).to receive(:url_scheme).and_return('http://')
    end

    it 'returns the preview domain and site label with the slug' do
      allow(ComfortableMexicanSofa.config).to receive(:preview_domain).and_return(domain)
      expect(presenter.preview_url).to eq('http://qa.contento.com/en/articles/investing/preview')
    end
  end
end
