RSpec.describe Hippo::DiffsController do
  let(:current_user) { create(:user) }
  let!(:site) { create(:site) }

  before do
    sign_in current_user
  end

  describe 'GET /hippo/diff' do
    let(:hippo_diff) { double }
    let(:data) { double }

    before do
      expect(controller).to receive(:data).and_return(data)
      expect(Cms::HippoDiff).to receive(:new).with(data: data).and_return(hippo_diff)
    end

    it 'assigns hippo pages' do
      get :show
      expect(assigns[:hippo_diff]).to eq(hippo_diff)
    end
  end
end
