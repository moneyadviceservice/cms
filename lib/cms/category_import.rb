require 'csv'

class CategoryImport
  PARENT_CATEGORIES = %w[
    saving-and-investing homes-and-mortgages insurance tools-and-calculators calculators
    comparison-tables letter-templates order-forms free-printed-guides videos news
    Partners partners-universal-credit-banks partners-banks-universal-credit
    frontline-guide-test partners-uc-banks our-debt-work interactive-timelines
    partners-uc-landlords resources-for-professionals-working-with-young-people-and-parents
    resources-for-professionals-supporting-young-people resources-for-professionals-supporting-parents
    research-and-toolkits-on-young-people-and-money benefits care-and-disability debt-and-borrowing
    budgeting-and-managing-money births-deaths-and-family cars-and-travel
    work-pensions-and-retirement
  ].freeze

  def import!
    create_parent_categories

    CSV.open(Rails.join('lib', 'cms', 'categories.csv'), headers: true).each do |category|
      begin
        Rails.logger.info("Migrating #{category['public_id']}")
        c = Comfy::Cms::Category.find_by!(label: category['public_id'])
        c.update!(attributes_for(category))
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info("Can not find category #{category['public_id']}")
      end
    end
  end

  private

  def attributes_for(category)
    {
      title_en: category['title_en'],
      title_cy: category['title_cy'],
      description_en: category['description_en'],
      description_cy: category['description_cy'],
      title_tag_en: category['title_tag_en'],
      title_tag_cy: category['title_tag_cy'],
      parent_id: new_parent_id(category['parent_id']),
      ordinal: category['ordinal'],
      navigation: category['navigation']
    }
  end

  def create_parent_categories
    PARENT_CATEGORIES.each do |label|
      category = Comfy::Cms::Category.find_or_initialize_by(label: label,
                                                            site_id: 1,
                                                            categorized_type: 'Comfy::Cms::Page')
      category.save(validate: false)
    end
  end

  def new_parent_id(old_parent_id)
    return '' if old_parent_id.blank? || old_parent_id == 'NULL'

    Comfy::Cms::Category.find_by(label: label_for(old_parent_id)).try(:id)
  end

  def label_for(old_parent_id)
    CSV.open(Rails.join('lib', 'cms', 'categories.csv'), headers: true).find do |category|
      category['id'] == old_parent_id
    end['public_id']
  rescue StandardError
    Rails.logger.info("#{old_parent_id} could not be found")
  end
end
