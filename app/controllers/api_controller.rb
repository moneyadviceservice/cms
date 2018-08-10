class APIController < ApplicationController
  respond_to :json
  attr_reader :current_site

  def find_site
    @current_site = Comfy::Cms::Site.find_by(path: params[:locale])

    render json: { message: %(Site "#{params[:locale]}" not found) }, status: :not_found if current_site.blank?
  end
end
