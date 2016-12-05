class ClumpSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  has_many :categories

  private

  def name
    scope == 'en' ? object.name_en : object.name_cy
  end

  def description
    scope == 'en' ? object.description_en : object.description_cy
  end

end
