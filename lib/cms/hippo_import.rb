require 'htmlentities'

class HippoImport
  TYPES = [
    'contentauthoringwebsite:Guide'
    # 'contentauthoringwebsite:ActionPlan',
    # 'contentauthoringwebsite:ToolPage',
    # 'contentauthoringwebsite:StaticPage',
    # 'contentauthoringwebsite:VideoPage',
    # 'contentauthoringwebsite:News'
  ]

  attr_reader :records, :html_decoder

  def initialize(data, site = 'en', parser = HippoXmlParser, html_decoder = HTMLEntities.new)
    @records = parser.parse(data, TYPES)
    @_site = site || 'en'
    @html_decoder = html_decoder
  end

  def site
    @site ||= Comfy::Cms::Site.find_by(label: @_site)
  end

  def layout
    @_layout ||= (site.try(:layouts) || []).first
  end

  def parent
    @_parent ||= Comfy::Cms::Page.where(parent_id: nil, site: site).first
  end

  def decoded(str)
    decoded = html_decoder.decode(str)
    html = Nokogiri::HTML.parse(decoded)
    remove_unused_elements(html)
    convert_videos(html)
    ReverseMarkdown.site = site
    ReverseMarkdown.convert(html)
  end

  def remove_unused_elements(html)
    ['//p[@class="intro"]/img', '//a[@class="action-email"]',
     '//form[@class="action-form"]', '//span[@class="collapse"]'].each do |path|
      html.xpath(path).remove
    end
  end

  def convert_videos(html)
    html.xpath('//iframe[starts-with(@src, "https://www.youtube.com/embed")]').each  do |e|
      e.replace('({' + e.attributes['src'].value.gsub('https://www.youtube.com/embed/', '') + '})')
    end
  end

  def import!
    records.map do |record|
      begin
        puts "Importing: #{record.id}"
        page = Comfy::Cms::Page.where(slug: record.id).first
        (page || Comfy::Cms::Page.new).tap do |p|
          p.site = site
          p.layout = layout
          p.parent = parent
          p.label = record.title
          p.slug = record.id
          p.created_at = record.created_at
          p.updated_at = record.updated_at
          p.meta_description = record.meta_description.present? ? record.meta_description : record.preview
          p.meta_title = record.title_tag
          p.state = 'draft'
          p.translation_id = record.translation_id
          p.blocks = [
            Comfy::Cms::Block.new(identifier: 'content', content: decoded(record.body.to_s))
          ]
          p.save unless page && page.state == 'published'
        end
      rescue => e
        puts "ERROR: #{e.inspect}"
      end
    end
  end
end
