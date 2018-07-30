module Prismic
  module Migrator
    class Insight < EvidenceHub
      def content_headers
        [
          OpenStruct.new(
            field: 'context',
            anchor: '<li><a href="#context">Context</a></li>',
            heading: '<h2 id="context">Context</h2>'
          ),
          OpenStruct.new(
            field: 'the_study',
            anchor: '<li><a href="#the-study">The study</a></li>',
            heading: '<h2 id="the-study">The study</h2>'
          ),
          OpenStruct.new(
            field: 'key_findings',
            anchor: '<li><a href="#key-findings">Key findings</a></li>',
            heading: '<h2 id="key-findings">Key findings</h2>'
          ),
          OpenStruct.new(
            field: 'points_to_consider',
            anchor: '<li><a href="#points">Points to consider</a></li>',
            heading: '<h2 id="points">Points to consider</h2>'
          )
        ]
      end

      def layout_identifier
        'insight'
      end

      def blocks
        [
          Comfy::Cms::Block.new(
            identifier: 'content',
            content: content_markdown,
            processed_content: content_html
          ),
          Comfy::Cms::Block.new(
            identifier: 'overview',
            content: document.overview_markdown,
            processed_content: document.overview
          ),
          Comfy::Cms::Block.new(
            identifier: 'countries',
            content: document.country_of_delivery,
            processed_content: document.country_of_delivery
          ),
          Comfy::Cms::Block.new(
            identifier: 'links_to_research',
            content: document.links_to_research_markdown,
            processed_content: document.links_to_research
          ),
          Comfy::Cms::Block.new(
            identifier: 'contact_information',
            content: document.contact_details_markdown,
            processed_content: document.contact_details
          ),
          Comfy::Cms::Block.new(
            identifier: 'year_of_publication',
            content: document.year_of_publication,
            processed_content: document.year_of_publication
          ),
          topics,
          countries_of_delivery,
          client_groups,
          qualitative,
          quantitative
        ].compact.flatten
      end

      def qualitative
        if document.qualitative == 'Yes'
          Comfy::Cms::Block.new(
            identifier: 'data_types',
            content: 'Qualitative',
            processed_content: Mastalk::Document.new('Qualitative').to_html
          )
        end
      end

      def quantitative
        if document.quantitative == 'Yes'
          Comfy::Cms::Block.new(
            identifier: 'data_types',
            content: 'Quantitative',
            processed_content: Mastalk::Document.new('Quantitative').to_html
          )
        end
      end
    end
  end
end
