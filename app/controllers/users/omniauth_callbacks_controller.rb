class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include OktaRoleMapper

  skip_before_filter :verify_authenticity_token

  def saml
    auth  = request.env['omniauth.auth']
    extra = request.env['omniauth.auth'].extra.response_object.attributes

    name  = "#{extra['firstName']} #{extra['lastName']}"
    role  = convert_okta_group_to_role(extra['role'])

    @user = Comfy::Cms::User.find_or_create_by(email: auth.uid) do |user|
      user.name     = name
      user.role     = role
      user.password = Devise.friendly_token
      user.provider = auth.provider
      user.uid      = auth.uid
    end

    if @user && @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'SAML'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = auth.except(:extra) # Removing extra as it can overflow some session stores
      redirect_to root_path, alert: @user.errors.full_messages.join("\n")
    end
  rescue
    redirect_to root_path, alert: "Invalid login"
  end

  def after_omniauth_failure_path_for(scope)
    # This should be a public route which tells the person they can't access this - currently a devise standard page
    root_path(scope)
  end
end
