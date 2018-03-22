class CategorySerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description, :parent_id,
             :third_level_navigation, :images, :legacy

  has_many :contents
  has_many :legacy_contents
  has_many :category_promos
  has_many :links, serializer: CategoryLinkSerializer

  def images
    {
      small: small_image_url,
      large: large_image_url
    }
  end

  def small_image_url
    return unless small_image?
    asset_url_for(:small_image)
  end

  def large_image_url
    return unless large_image?
    asset_url_for(:large_image)
  end

  def asset_url_for(asset)
    image_url = object.send(asset).try(:file).try(:url).to_s
    URI.join(ActionController::Base.asset_host, image_url).to_s
  end

  def category_promos
    object.category_promos.where(locale: scope)
  end

  def base_contents(legacy: false)
    (
      object.find_children(legacy: legacy) <<
      Comfy::Cms::Page
        .in_locale(scope)
        .in_category(object.id)
        .map { |p| PageCategorySerializer.new(p) }
    ).flatten.compact
  end

  def contents
    base_contents
  end

  def legacy_contents
    base_contents(legacy: true)
  end

  def id
    object.label
  end

  def links
    object.links.where(locale: scope)
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

  def small_image?
    object.small_image
  end

  def large_image?
    object.large_image
  end

  def legacy
    object.find_children(legacy: true).any?
  end
end
