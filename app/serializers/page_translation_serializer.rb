class PageTranslationSerializer < ActiveModel::Serializer
  attributes :label, :link, :language

  def link
    PagePresenter.new(object).link
  end

  def language
    object.site.path
  end
end
