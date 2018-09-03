require 'nokogiri'

class TableCaptioner
  attr_reader :source

  def initialize(_locale, source)
    @source = source
  end

  def call
    process!
    doc.to_s
  end

  private

  def process!
    table_nodes.each do |node|
      next unless (next_element = node.next_element || node.parent.next_element)

      if next_element.name == 'p' && next_element.attributes['class'].try(:value) == 'caption'
        node.children.before("<caption>#{next_element.text.strip}</caption>")
        next_element.remove
      end
    end
  end

  def doc
    @doc ||= Nokogiri::HTML.fragment(source)
  end

  def table_nodes
    @table_nodes ||= doc.css('table')
  end
end
