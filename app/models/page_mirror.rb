class PageMirror
  def self.collect(pages)
    remove_mirror_duplication(pages).collect { |page| new(page) }
  end

  def self.remove_mirror_duplication(pages)
    pages.inject([]) do |mirror, page|
      mirror.tap do |list|
        list.push(page) if (mirror & [page, page.mirrors].flatten).blank?
      end
    end
  end

  attr_reader :page
  delegate :label, to: :page, prefix: true

  def initialize(page)
    @page = page
  end

  def label(language)
    mirror(language).try(:label)
  end

  def url(language)
    language_mirror = mirror(language)
    return if language_mirror.blank?

    "/#{language_mirror.site.path}/articles/#{language_mirror.slug}".squeeze('/')
  end

  def mirror(language)
    find_mirror(language)
  end

  def ==(other)
    page_equal?(:en, other) && page_equal?(:cy, other)
  end

  def inspect
    english = "english_label: '#{label(:en)}', english_url: '#{url(:en)}'"
    welsh   = "welsh_label: '#{label(:cy)}', welsh_url: '#{url(:cy)}'"

    "#<#{self.class} #{english}, #{welsh}>"
  end

  private

  def find_mirror(language)
    return page if page.site.label == language.to_s

    mirrors.find { |mirror| mirror.site.label == language.to_s }
  end

  def page_equal?(language, other)
    label(language) == other.label(language) && url(language) == other.url(language)
  end

  def mirrors
    @mirrors ||= page.mirrors
  end
end
