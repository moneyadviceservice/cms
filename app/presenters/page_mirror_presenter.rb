class PageMirrorPresenter < Presenter
  def mirror(language)
    PageMirrorPresenter.new(object.mirror(language))
  end

  def label
    object.label(:en) || object.page_label
  end

  def disabled?
    (published? || published_being_edited?).blank?
  end
end
