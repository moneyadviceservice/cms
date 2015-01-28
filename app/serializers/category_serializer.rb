class CategorySerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description

  has_many :contents

  private

  def id
    object.label
  end

  def title
    scope == :en ? object.title_en : object.title_cy
  end

  def description
    scope == :en ? object.description_en : object.description_cy
  end

  def type
    'category'
  end
end
