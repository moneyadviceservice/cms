module API
  class CategoryContentsController < APIController
    def index
      @primary_navigation, @secondary_navigation = Comfy::Cms::Category.navigation_categories
      render json: @primary_navigation, scope: params[:locale].to_sym
    end

    def show
      @category = Comfy::Cms::Category.find_by(label: params[:id])
      render json: @category, scope: params[:locale].to_sym
    end
  end
end
