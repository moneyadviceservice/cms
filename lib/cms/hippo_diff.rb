module Cms
  class HippoDiff
    attr_reader :parser, :data
    delegate :each, to: :collection

    HIPPO_TYPES = [
      'contentauthoringwebsite:Guide',
      'contentauthoringwebsite:ActionPlan',
      'contentauthoringwebsite:ToolPage',
      'contentauthoringwebsite:StaticPage',
      'contentauthoringwebsite:VideoPage',
      'contentauthoringwebsite:News',
      'contentauthoringwebsite:Campaign'
    ]

    def initialize(data:, parser: HippoXmlParser)
      @parser = parser
      @data = data
    end

    def collection
      @collection ||= hippo_pages.reject { |record| record.id.in?(contento_slugs) }
    end

    def hippo_pages
      @records ||= parser.parse(data, HIPPO_TYPES)
    end

    def contento_slugs
      @contento_slugs ||= Comfy::Cms::Page.pluck(:slug)
    end
  end
end
