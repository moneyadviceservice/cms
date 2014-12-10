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

      context 'when another site has files' do
        let!(:welsh) { create(:site, :welsh, :with_files) }

        it 'does not redirect to the new action' do
          get :index, site_id: site.id
          expect(response).to_not redirect_to(action: :new)
        end
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

    context 'when another site has files' do
      let!(:site)       { create(:site, :with_files) }
      let!(:welsh_site) { create(:site, :welsh, :with_files) }

      before do
        get :index, site_id: site.id
      end

      it 'assigns files from different sites' do
        files = [site.files, welsh_site.files].flatten
        expect(assigns[:files]).to match_array(files)
      end

      it 'responds success' do
        expect(response).to be_success
      end
    end
  end
end
