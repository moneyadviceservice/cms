RSpec.describe FilesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /files' do
    before do
      get :index, site_id: site.id
    end

    context 'when site has no files' do
      let!(:site) { create(:site) }

      it 'redirect to new action' do
        expect(response).to redirect_to(action: :new)
      end
    end

    context 'when site has files' do
      let!(:site) { create(:site, :with_files) }

      it 'assigns files' do
        expect(assigns[:files]).to match_array(site.files)
      end

      it 'responds success' do
        expect(response).to be_success
      end
    end
  end
end
