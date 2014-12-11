RSpec.describe Links::ImagesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /links/images' do
    before do
      get :index, site_id: site.id
    end

    context 'when site has no files' do
      let!(:site) { create(:site) }

      it 'assigns empty files' do
        expect(assigns[:files]).to eq([])
      end
    end

    context 'when site has only image files' do
      let!(:site) { create(:site, :with_files) }

      it 'assigns site files' do
        expect(assigns[:files]).to match_array(site.files)
      end
    end

    context 'when site has only document files' do
      let!(:site) { create(:site, :with_document_files) }

      it 'assigns empty files' do
        expect(assigns[:files]).to eq([])
      end
    end
  end
end
