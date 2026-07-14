RSpec.describe Links::ImagesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /links/images' do
    subject(:get_index) { get :index, site_id: site.id }

    context 'when site has no files' do
      let!(:site) { create(:site) }

      it 'assigns empty files' do
        get_index
        expect(assigns[:files]).to eq([])
      end
    end

    context 'when site has only image files' do
      let!(:site) { create(:site, :with_files) }

      include_examples 'controller assigns presented site files' do
        let(:sites) { [site] }
      end
    end

    context 'when site has only document files' do
      let!(:site) { create(:site, :with_document_files) }

      it 'assigns empty files' do
        get_index
        expect(assigns[:files]).to eq([])
      end
    end
  end
end
