RSpec.describe UsersController, type: :controller  do
  describe 'GET edit' do
    let!(:site) { create(:site) }

    before { sign_in user }

    let(:user) { create(:user, role: role) }
    let(:other_user) { create(:user) }

    context 'non admin' do
      let(:role) { Comfy::Cms::User.roles[:user] }

      context 'editing someone else\'s user' do
        before { get :edit, id: other_user.id }
        it { is_expected.to redirect_to :root }
      end

      context 'editing my user' do
        before { get :edit, id: user.id }
        it { is_expected.to respond_with 200 }
      end
    end

    context 'admin' do
      let(:role) { Comfy::Cms::User.roles[:admin] }

      context 'editing someone else\'s user' do
        before { get :edit, id: other_user.id }
        it { is_expected.to respond_with 200 }
      end

      context 'creating a user' do
        it 'allows the role (as an integer) to be set' do
          allow(Comfy::Cms::User).to receive(:new).and_return(double(save: true))
          post :create, comfy_cms_user: { role: '1' }
          expect(Comfy::Cms::User).to have_received(:new).with(role: 1)
        end
      end
    end
  end
end
