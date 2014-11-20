require 'spec_helper'

RSpec.describe NotesController do
  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end

  describe 'POST /notes' do
    let(:page) { create(:page) }

    context 'when valid' do
      before do
        post :create, format: :js, site_id: page.site_id, page_id: page.id, description: 'note-text'
      end

      it 'creates the page note' do
        expect(assigns[:note]).to be_persisted
        expect(assigns[:note].data).to eq(
          note: 'note-text',
          author: {
            id:   current_user.id,
            name: current_user.name
          }
        )
      end

      it 'assigns the activity log presenter' do
        expect(assigns[:activity_log]).to be_a(ActivityLogPresenter)
      end

      it 'returns created status code' do
        expect(response.status).to be 201
      end
    end

    context 'when invalid' do
      before do
        post :create, format: :js, site_id: page.site_id, page_id: page.id
      end

      it 'does not create the note for the page' do
        expect(assigns[:note]).to_not be_persisted
      end

      it 'returns bad request' do
        expect(response.status).to be 400
      end
    end
  end
end
