module Cms
  class HippoDiff
    attr_reader :parser, :data

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

    def slugs
      @slugs ||= parser.parse(data, HIPPO_TYPES).map(&:id)
    end

    def contento_slugs
      Comfy::Cms::Page.pluck(:slug)
    end
  end
end
