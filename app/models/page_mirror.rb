class PageMirror
  def self.collect(pages)
    pages.collect { |page| new(page) }
  end

  attr_reader :page

  def initialize(page)
    @page = page
  end

  def label(language)
    find_mirror(language).label
  end

  def url(language)
    find_mirror(language).url
  end

  def inspect
    english = "english_label: '#{label(:en)}', english_url: '#{url(:en)}'"
    welsh   = "welsh_label: '#{label(:cy)}', welsh_url: '#{url(:cy)}'"

    "#<#{self.class} #{english}, #{welsh}>"
  end

  private

  def find_mirror(language)
    mirrors.find { |mirror| mirror.site.label == language.to_s } || page
  end

  def mirrors
    @mirrors ||= page.mirrors
  end
end

