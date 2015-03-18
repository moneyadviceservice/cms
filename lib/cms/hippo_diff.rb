module Cms
  class HippoDiff
    attr_reader :parser, :data
    delegate :each, :size, to: :collection

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
      @records ||= parser.parse(data, HIPPO_TYPES).map { |record| HippoPage.new(record) }
    end

    def contento_slugs
      @contento_slugs ||= Comfy::Cms::Page.pluck(:slug)
    end
  end

  class HippoPage
    PAGE_TYPES = {
      'contentauthoringwebsite:Guide' => 'articles',
      'contentauthoringwebsite:ActionPlan' => 'action_plans',
      'contentauthoringwebsite:ToolPage' => 'tools',
      'contentauthoringwebsite:StaticPage' => 'static',
      'contentauthoringwebsite:VideoPage' => 'videos',
      'contentauthoringwebsite:News' => 'news',
      'contentauthoringwebsite:Campaign' => 'campaigns'
    }

    delegate :id, to: :record
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def link
      "http://moneyadviceservice.org.uk/en/#{PAGE_TYPES[type]}/#{record.id}"
    end

    def type
      @type ||= record.fetch('jcr:primaryType')
    end

    def ==(other)
      id == other.id
    end
  end
end
