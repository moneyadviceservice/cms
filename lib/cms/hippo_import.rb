require 'htmlentities'

class HippoImport
  TYPES = [
    'contentauthoringwebsite:Guide',
    'contentauthoringwebsite:ActionPlan',
    'contentauthoringwebsite:ToolPage',
    'contentauthoringwebsite:StaticPage',
    'contentauthoringwebsite:VideoPage',
    'contentauthoringwebsite:News'
  ]


  attr_reader :records, :html_decoder
  def initialize(data, parser=HippoXmlParser, html_decoder=HTMLEntities.new)
    @records = parser.parse(data, TYPES)
    @html_decoder = html_decoder
  end

  def site
    @_site ||=Comfy::Cms::Site.first
  end

  def layout
    @_layout ||= Comfy::Cms::Layout.first
  end

  def parent
    @_parent ||= Comfy::Cms::Page.where(parent_id: nil).first
  end

  def decoded(str)
    html_decoder.decode(str)
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
          p.state = 'draft'
          p.blocks = [
            Comfy::Cms::Block.new(identifier: 'content', content: decoded(record.body.to_s))
          ]
          p.save unless (page && page.state == "published")
        end
      rescue => e
        puts "ERROR: #{e.inspect}"
      end
    end
  end
end