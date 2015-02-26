class CategoryLocaleMigration
  def call
    welsh_categorizations.each do |welsh_cat|
      welsh_cat.update_attributes!(category_id: english_category_for(welsh_cat))
    end
  end

  def delete!
    welsh_categories.delete_all
  end

  private

  def welsh_categories
    Comfy::Cms::Category.where(site_id: 2)
  end

  def welsh_categorizations
    Comfy::Cms::Categorization.where(category_id: welsh_categories.pluck(:id))
  end

  def english_category_for(welsh_cat)
    Comfy::Cms::Category.find_by(site_id: 1, label: welsh_category_label(welsh_cat)).id
  end

  def welsh_category_label(welsh_cat)
    Comfy::Cms::Category.find(welsh_cat.category_id).label
  end
end
