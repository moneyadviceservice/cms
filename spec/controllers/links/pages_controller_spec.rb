RSpec.describe Links::PagesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /links/pages' do
    let(:site) { create(:site) }

    before do
      get :index, format: :js, site_id: site.id, search: 'page label'
    end

    it 'assigns pages' do
      expect(assigns[:pages]).to eq([])
    end

    it 'returns success code' do
      expect(response.status).to be 200
    end
  end
end

