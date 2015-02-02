class PageCategorySerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description

  private

  def id
    object.slug
  end

  def title
    object.label
  end

  def description
    object.meta_description
  end

  def type
    'guide'
  end
end
