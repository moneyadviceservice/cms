require 'spec_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let!(:auth_hash) { OmniAuth.config.mock_auth[:okta] }

  describe "#create" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth']  = auth_hash
    end

    context "with a valid auth hash" do
      it "creates a user" do
        expect {
          get :saml, provider: :okta
        }.to change{ Comfy::Cms::User.count }.by(1)
      end

      it 'assign the user a role' do
        get :saml, provider: :okta
        expect(Comfy::Cms::User.last.role).to_not be_nil
      end
#
      it "creates a session" do
        expect(session["warden.user.user.key"]).to be_nil
        get :saml, provider: :okta
        expect(session["warden.user.user.key"]).to_not be_nil
      end

      it "redirects to the root url" do
        get :saml, provider: :okta
        expect(response).to redirect_to root_url
      end
    end

    context "without a valid auth hash" do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env['omniauth.auth']  = {}
      end

      it "does not create a session" do
        get :saml, provider: :okta
        expect(session["warden.user.user.key"]).to be_nil
      end

      it 'redirects to root path' do
        get :saml, provider: :okta
        expect(response).to redirect_to root_url
      end
    end
  end
end
