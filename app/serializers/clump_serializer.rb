class ClumpSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :categories

  private

  def name
    scope == 'en' ? object.name_en : object.name_cy
  end

end
