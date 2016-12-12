class ClumpLinkSerializer < ActiveModel::Serializer
  attributes :id, :text, :url, :style

  private

  def text
    scope == 'en' ? object.text_en : object.text_cy
  end

  def url
    scope == 'en' ? object.url_en : object.url_cy
  end
end
