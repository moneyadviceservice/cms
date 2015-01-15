require 'csv'

class CategoryImport
  def import!
    create_parent_categories

    CSV.open("#{Rails.root}/lib/cms/categories.csv", headers: true).each do |category|
      begin
        Comfy::Cms::Category.find_by!(label: category['public_id']).update_attributes!(
          title_en: category['title_en'],
          title_cy: category['title_cy'],
          description_en: category['description_en'],
          description_cy: category['description_cy'],
          title_tag_en: category['title_tag_en'],
          title_tag_cy: category['title_tag_cy'],
          parent_id: new_parent_id(category['parent_id']),
          ordinal: category['ordinal'],
          navigation: category['navigation']
        )
      rescue ActiveRecord::RecordNotFound
        puts "Can not find c1ategory #{category['public_id']}"
      end
    end
  end

  private

  def create_parent_categories
    %w(saving-and-investing homes-and-mortgages insurance tools-and-calculators calculators
      comparison-tables letter-templates order-forms free-printed-guides videos news
      Partners partners-universal-credit-banks partners-banks-universal-credit
      frontline-guide-test partners-uc-banks our-debt-work interactive-timelines
      partners-uc-landlords resources-for-professionals-working-with-young-people-and-parents
      resources-for-professionals-supporting-young-people resources-for-professionals-supporting-parents
      research-and-toolkits-on-young-people-and-money benefits care-and-disability debt-and-borrowing
      budgeting-and-managing-money births-deaths-and-family cars-and-travel
      work-pensions-and-retirement).each do |label|
      Comfy::Cms::Category.find_or_create_by!(label: label, site_id: 1, categorized_type: "Comfy::Cms::Page")
    end
  end

  def new_parent_id(old_parent_id)
    return '' if old_parent_id.blank? || old_parent_id == 'NULL'
    Comfy::Cms::Category.find_by(label: label_for(old_parent_id)).try(:id)
  end

  def label_for(old_parent_id)
    begin
      CSV.open("#{Rails.root}/lib/cms/categories.csv", headers: true).find do |category|
        category['id'] == old_parent_id
      end['public_id']
    rescue => e
      # puts "#{old_parent_id}"
    end
  end
end