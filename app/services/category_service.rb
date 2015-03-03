class CategoryService
  attr_reader :category, :category_params, :sub_category_params

  def initialize(category, category_params, sub_category_params)
    @category = category
    @category_params = category_params
    @sub_category_params = sub_category_params
  end

  def update_category!
    Comfy::Cms::Category.transaction do
      category.update!(category_params)
      update_sub_categories
      update_page_order(:list_order_pages_en)
      update_page_order(:list_order_pages_cy)
    end
  end

  def update_sub_categories
    list_order(:list_order_sub_categories).each_with_index do |category_id, index|
      Comfy::Cms::Category.find(category_id).update!(ordinal: index + 1)
    end
  end

  private

  def update_page_order(locale)
    list_order(locale).each_with_index do |page_id, index|
      categorization(page_id).update!(ordinal: index + 1)
    end
  end

  def categorization(page_id)
    Comfy::Cms::Categorization.find_by(categorized_id: page_id, category_id: category.id)
  end

  def list_order(type)
    sub_category_params[type].to_s.split(',')
  end
end
