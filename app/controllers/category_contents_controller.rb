class CategoryContentsController < ApplicationController
  skip_before_action :load_cms_page

  def index
    @primary_navigation, @secondary_navigation = Comfy::Cms::Category.navigation_categories
    render json: @primary_navigation, scope: params[:locale].to_sym
  end
end
