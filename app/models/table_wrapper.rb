require 'nokogiri'

class TableWrapper
  attr_reader :source

  def initialize(_, source)
    @source = source
  end

  def call
    doc = Nokogiri::HTML.fragment(source)
    nodes = doc.css 'table'
    nodes.wrap('<div class="table-wrapper"></div>')
    doc.to_s
  end
end
