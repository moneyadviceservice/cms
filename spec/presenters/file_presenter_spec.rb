RSpec.describe FilePresenter do
  subject(:presenter) { described_class.new(file) }
  let(:file) { build(:file) }

  describe '#full_path' do
    let(:site) { build(:site) }
    let(:file) { double(site: site, file: double(url: 'foo-bar')) }

    it 'returns the file url' do
      expect(presenter.full_path).to eq('foo-bar')
    end
  end

  describe '#edit_url' do
    let(:site) { build(:site, id: 1) }
    let(:file) { build(:file, id: 2, site: site) }

    it 'returns file edit path' do
      expect(presenter.edit_url).to eq('/admin/sites/1/files/2/edit')
    end
  end

  describe '#image_tag_code' do
    it 'generates image element with source and description' do
      expected = "<img src='#{subject.full_path}' alt='Default Description'>"
      expect(subject.image_tag_code).to eql(expected)
    end
  end
end
