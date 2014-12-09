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
end
