RSpec.describe PageFeedbacksController do
  let(:current_user) { create(:user, role: Comfy::Cms::User.roles[:user]) }

  before do
    sign_in current_user
  end

  describe 'GET /page_feedbacks' do
    let!(:page_feedback) { create(:page_feedback) }

    it 'assigns page feedbacks' do
      get :index, site_id: page_feedback.page.site_id
      expect(assigns[:page_feedbacks]).to match_array([page_feedback])
    end
  end
end
