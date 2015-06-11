class CategorySerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description, :parent_id,
             :third_level_navigation, :images

  has_many :contents

  private

  def images
    {
      small: URI.join(ActionController::Base.asset_host, object.small_image.try(:file).try(:url).to_s).to_s,
      large: URI.join(ActionController::Base.asset_host, object.large_image.try(:file).try(:url).to_s).to_s
    }
  end

  def contents
    (
      object.child_categories <<
      Comfy::Cms::Page
        .in_locale(scope)
        .in_category(object.id)
        .map { |p| PageCategorySerializer.new(p) }
    ).flatten.compact
  end

  def id
    object.label
  end

  def title
    scope == 'en' ? object.title_en : object.title_cy
  end

  def description
    scope == 'en' ? object.description_en : object.description_cy
  end

  def type
    'category'
  end

  def parent_id
    return '' unless object.parent_id.present?
    Comfy::Cms::Category.find(object.parent_id).label
  end

  def third_level_navigation
    object.third_level_navigation
  end
end
