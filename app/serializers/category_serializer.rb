class CategorySerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description, :parent_id

  has_many :contents

  private

  def contents
    (
      object.child_categories <<
      Comfy::Cms::Page.in_category(object.id).map { |p| PageCategorySerializer.new(p) }
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
end
