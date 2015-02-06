class APIController < ApplicationController
  respond_to :json
  attr_reader :current_site

  def find_site
    @current_site = Comfy::Cms::Site.find_by(path: params[:locale])

    render json: { message: %(Site "#{params[:locale]}" not found) }, status: 404 if current_site.blank?
  end
end
