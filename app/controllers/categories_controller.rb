class CategoriesController < Comfy::Admin::Cms::BaseController
  def index
    categories = Comfy::Cms::Category.where(site_id: 1, parent_id: nil).reorder(:ordinal)
    @primary_navigation, @secondary_navigation = categories.partition(&:navigation?)
  end

  def show
    @category = Comfy::Cms::Category.find(params[:id])
    @child_categories = Comfy::Cms::Category.where(site_id: 1, parent_id: @category.id, navigation: true).reorder(:ordinal)
    categorizations = Comfy::Cms::Categorization.where(category_id: @category.id).pluck(:categorized_id)
    @pages = Comfy::Cms::Page.where(id: categorizations)
  end

  def update
    @category = Comfy::Cms::Category.find(params[:id])
    @category.update_attributes!(category_params)
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
end
