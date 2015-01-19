class CategoriesController < Comfy::Admin::Cms::BaseController
  before_action :find_category, only: [:show, :update]

  def index
    @primary_navigation, @secondary_navigation = Comfy::Cms::Category.navigation_categories
  end

  def show
    @pages = Comfy::Cms::Page.in_category(@category.id)
  end

  def update
    CategoryService.new(@category, category_params, params).update_category
    redirect_to action: :show
  end

  private

  def category_params
    params.require(:comfy_cms_category).permit(
      :title_en,
      :title_cy,
      :description_en,
      :description_cy,
      :ordinal,
      :navigation
    )
  end

  def find_category
    @category = Comfy::Cms::Category.find(params[:id])
  end
end
