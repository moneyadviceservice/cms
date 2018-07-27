module Prismic
  module Migrator
    class Insight < Base
      CONTENT_HEADERS = [
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
      ].freeze
      FULL_REPORT_HEADER = '<h2>Full report</h2>'.freeze

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

      def topics
        document.topics.collect(&:values).flatten.map do |topic|
          Comfy::Cms::Block.new(
            identifier: 'topics',
            content: topic,
            processed_content: Mastalk::Document.new(topic).to_html
          )
        end
      end

      def countries_of_delivery
        document.country_search_filter_group.map(&:values).flatten.map do |country|
          country_value = country.gsub(/\d/, '')

          Comfy::Cms::Block.new(
            identifier: 'country_of_delivery',
            content: country_value,
            processed_content: Mastalk::Document.new(country_value).to_html
          )
        end
      end

      def client_groups
        Array(document.client_groups).map(&:values).flatten.map do |client_group|
          Comfy::Cms::Block.new(
            identifier: 'client_groups',
            content: client_group,
            processed_content: Mastalk::Document.new(client_group).to_html
          )
        end
      end

      def content_html
        html = '<ol>'

        CONTENT_HEADERS.each do |context_header|
          content = document.send(context_header.field)

          html << context_header.anchor if content.present?
        end

        html << '</ol>'

        CONTENT_HEADERS.each do |context_header|
          content = document.send(context_header.field)

          if content.present?
            html << context_header.heading
            html << content
          end
        end

        if document.links_to_research.present?
          html << FULL_REPORT_HEADER
          html << document.links_to_research
        end

        html
      end

      def content_markdown
        ReverseMarkdown.convert(content_html)
      end
    end
  end
end
