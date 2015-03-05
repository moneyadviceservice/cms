require 'csv'

class PageCategoryOrder
  def call
    CSV.open("#{Rails.root}/lib/cms/page_order.csv", headers: true).each do |row|
      category = Comfy::Cms::Category.find_by(label: row['category'])
      page = Comfy::Cms::Page.find_by(slug: row['article'])
      ordinal = row['ordinal']

      categorization = Comfy::Cms::Categorization.find_or_create_by(
        category_id: category.id,
        categorized_id: page.id
      )
      categorization.update_attributes(ordinal: ordinal)
    end
  end
end
