require 'nokogiri'

class ExternalLink
  attr_reader :source, :screen_reader_tag

  def initialize(source)
    @source = source
    @screen_reader_tag = '<span class="visually-hidden">open in a tab</span>'
    freeze
  end

  def call
    doc = Nokogiri::HTML.fragment(source)
    nodes = doc.css 'a[target="_blank"]'
    nodes.after(screen_reader_tag) if nodes.present?
    doc.to_s
  end
end
