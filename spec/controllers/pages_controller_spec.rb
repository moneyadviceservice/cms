require 'spec_helper'

RSpec.describe PagesController do
  before do
    sign_in create(:user)
  end

  describe 'GET /pages' do
    let(:page) { create(:page) }
    let(:site) { page.site }

    context 'when searching pages' do
      before do
        get :index, site_id: site.id, search: page.label
      end

      it 'assigns filters variable' do
        expect(assigns[:filters_present]).to be_truthy
      end

      it 'assigns pages using the comfy search' do
        expect(assigns[:pages]).to match_array([page])
      end
    end

    context 'when filtering pages' do
      let(:page) do
        create(:page,
          label: 'test1',
          slug:   'test1',
          parent: create(:child_page)
        )
      end

      let!(:another_page) do
        create(:page,
          site:   page.site,
          label:  'test2',
          slug:   'test2',
          parent: create(:child_page),
          layout: create(:layout, :nested)
        )
      end

      before do
        get :index, site_id: site.id, layout: :nested
      end

      it 'does not assign filters variable' do
        expect(assigns[:filters_present]).to be_falsy
      end

      it 'assigns pages filtering the results' do
        expect(assigns[:pages]).to match_array([another_page])
      end
    end
  end
end