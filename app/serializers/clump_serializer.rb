class ClumpSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :links

  has_many :categories

  private

  def name
    scope == 'en' ? object.name_en : object.name_cy
  end

  def description
    scope == 'en' ? object.description_en : object.description_cy
  end

  def links
    object.clump_links.select(&:complete?).map do |link|
      ClumpLinkSerializer.new(link, scope: scope)
    end
  end
end
