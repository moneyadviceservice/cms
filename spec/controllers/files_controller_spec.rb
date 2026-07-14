RSpec.describe FilesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /files' do
    subject(:get_index) { get :index, site_id: site.id }

    context 'when site has no files' do
      let!(:site) { create(:site) }

      it 'redirect to new action' do
        get_index
        expect(response).to redirect_to(action: :new)
      end

      context 'when another site has files' do
        let!(:welsh) { create(:site, :welsh, :with_files) }

        it 'does not redirect to the new action' do
          get_index
          expect(response).to_not redirect_to(action: :new)
        end
      end
    end

    context 'when site has files' do
      let!(:site) { create(:site, :with_files) }

      include_examples 'controller assigns presented site files' do
        let(:sites) { [site] }
      end
    end

    context 'when another site has files' do
      let!(:site)       { create(:site, :with_files) }
      let!(:welsh_site) { create(:site, :welsh, :with_files) }

      include_examples 'controller assigns presented site files' do
        let(:sites) { [site, welsh_site] }
      end
    end
  end
end
