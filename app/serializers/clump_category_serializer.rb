class ClumpCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :contents, :type

  def id
    object.label
  end

  def title
    scope == 'en' ? object.title_en : object.title_cy
  end

  def type
    'category'
  end

  def contents
    object.find_children(legacy: false).map do |subcategory|
      ClumpCategorySerializer.new(subcategory, except: :contents, scope: scope)
    end
  end
end
