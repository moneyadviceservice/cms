RSpec.describe UsersController, type: :controller  do
  describe 'GET edit' do
    let!(:site) { create(:site) }

    before { sign_in user }

    let(:user) { create(:user, admin: admin) }
    let(:other_user) { create(:user) }

    context 'non admin' do
      let(:admin) { false }

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
      let(:admin) { true }

      context 'editing someone else\'s user' do
        before { get :edit, id: other_user.id }
        it { is_expected.to respond_with 200 }
      end
    end
  end
end
