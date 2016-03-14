class ApplicationController < ActionController::Base
  protected

  def check_admin
    redirect_to root_url unless current_user.admin?
  end

  def english_site
    @english_site ||= Comfy::Cms::Site.find_by(label: 'en')
  end
  helper_method :english_site
end
