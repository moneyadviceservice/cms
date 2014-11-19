require 'spec_helper'

RSpec.describe NotesController do
  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end

  describe 'POST /notes' do
    let(:page) { create(:page) }

    before do
      post :create, site_id: page.site_id, page_id: page.id, description: 'note-text'
    end

    it 'creates the page note' do
      expect(assigns[:note]).to be_persisted
      expect(assigns[:note].data).to eq(
        note: {
          to: 'note-text'
        },
        author: {
          id:   current_user.id,
          name: current_user.name
        }
      )
    end
  end
end
