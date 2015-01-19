class CategoryService
  attr_reader :category, :category_params, :sub_category_params

  def initialize(category, category_params, sub_category_params)
    @category = category
    @category_params = category_params
    @sub_category_params = sub_category_params
  end

  def update_category
    Comfy::Cms::Category.transaction do
      category.update_attributes!(category_params)
      update_sub_categories
      update_page_order
    end
  end

  private

  def update_sub_categories
    list_order_sub_categories.each_with_index do |category_id, index|
      Comfy::Cms::Category.find(category_id).update_attributes!(ordinal: index + 1)
    end
  end

  def update_page_order
    list_order_pages.each_with_index do |page_id, index|
      Comfy::Cms::Categorization.find_by(categorized_id: page_id).update_attributes!(ordinal: index + 1)
    end
  end

  def list_order_sub_categories
    (sub_category_params[:list_order_sub_categories] || []).split(',').flatten
  end

  def list_order_pages
    (sub_category_params[:list_order_pages] || []).split(',').flatten
  end
end
