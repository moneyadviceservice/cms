class ApplicationController < ActionController::Base
  protected

  def check_admin
    redirect_to root_url unless current_user.admin?
  end
end
