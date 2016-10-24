require 'nokogiri'

class ExternalLink
  attr_reader :locale, :source, :description

  def initialize(locale, source)
    @source = source
    @locale = locale.to_s.downcase.to_sym
    @description = { en: 'opens in new window', cy: 'yn agor mewn ffenestr newydd' }
    freeze
  end

  def call
    doc = Nokogiri::HTML.fragment(source)
    nodes = doc.css 'a[target="_blank"]'
    nodes.after(screen_reader_tag) if nodes.present?
    doc.to_s
  end

  private

  def screen_reader_tag
    [
      '<span class="visually-hidden">',
      description.fetch(locale, description[:en]),
      '</span>'
    ].join
  end
end
