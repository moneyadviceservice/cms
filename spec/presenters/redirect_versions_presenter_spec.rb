RSpec.describe RedirectVersionsPresenter do
  describe '#last updated by' do
    subject(:last_updated_by) { described_class.new(redirect_version).last_updated_by }

    context 'user exists' do
      let(:user) { create(:user, email: 'example@test.com') }
      let(:redirect_version) { double('redirect_version', user: user) }

      it "presents the identifier before the @-sign in user's email" do
        expect(last_updated_by).to eq('example')
      end
    end

    context 'user does not exist' do
      let(:redirect_version) { double('redirect_version', user: nil) }

      it 'shows a helpful message' do
        expect(last_updated_by).to eq('deleted user')
      end
    end
  end
end
