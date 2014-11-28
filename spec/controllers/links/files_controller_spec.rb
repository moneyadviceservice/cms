RSpec.describe Links::FilesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /links/files' do
    before do
      get :index, site_id: site.id
    end

    context 'when site has no files' do
      let!(:site) { create(:site) }

      it 'assigns empty files' do
        expect(assigns[:files]).to eq([])
      end
    end

    context 'when site has links' do
      let!(:site) { create(:site, :with_files) }

      it 'assigns site files' do
        expect(assigns[:files]).to match_array(site.files)
      end
    end
  end
end
