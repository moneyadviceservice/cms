require 'nokogiri'

class InternalLink
  attr_reader :source, :doc, :sections, :internal_links_menu

  def initialize(_, source)
    @source              = source
    @doc                 = Nokogiri::HTML.fragment(source)
    @sections            = doc.css('h2')
    @internal_links_menu = doc.css(existing_menu_selector(@sections[0])) if @sections[0]
    freeze
  end

  def call
    @sections.before(internal_links) if sections.present? && !internal_links_menu.present?
    doc.to_s
  end

  private

  def internal_links
    [
      '<ul>',
      list_items,
      '</ul>',
      "\n"
    ].join
  end

  def list_items
    sections
      .map(&add_id_attribute)
      .map(&to_li_tag).join
  end

  def add_id_attribute
    lambda do |node|
      node['id'] = parse_id(node.content)
      node
    end
  end

  def to_li_tag
    ->(node) { ['<li><a href="#', parse_id(node.content), '">', node.content, '</a></li>'].join }
  end

  def parse_id(s)
    s.downcase.tr(' ', '-')
  end

  def existing_menu_selector(node)
    [
      'a[href="#',
      parse_id(node.content),
      '"]'
    ].join('')
  end
end
