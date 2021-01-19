class OmniauthController < ApplicationController
  def localized
     session[:omniauth_login_locale] = I18n.locale
     redirect_to user_omniauth_authorize_path(params[:provider])
  end
end
