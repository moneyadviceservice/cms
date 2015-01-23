RSpec.describe HipposController do
  let!(:site) { create(:site, locale: 'en', path: 'en') }
  let!(:layout) { create(:layout, :article, site: site) }
  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end

  describe 'POST /hippos' do
    let(:tempfile) { Rails.root.join('spec', 'fixtures', 'example.xml') }
    let(:hippo_file) do
      ActionDispatch::Http::UploadedFile.new(tempfile: tempfile)
    end

    before do
      post :create, hippo_importer_form: params
    end

    context 'when valid' do
      let(:params) do
        { site: 'en', migration_type: 'article', hippo_file: hippo_file, slugs: 'do-you-need-to-borrow-money' }
      end

      it 'creates a page' do
        expect(assigns[:records].first.slug).to eq('do-you-need-to-borrow-money')
      end
    end

    context 'when invalid' do
      let(:params) do
        { site: 'en' }
      end

      it 'assigns records as nil' do
        expect(assigns[:records]).to be_nil
      end
    end
  end
end
