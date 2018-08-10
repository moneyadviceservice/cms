module Prismic
  module Migrator
    class EvidenceHub < Base
      FULL_REPORT_HEADER = '<h2>Full report</h2>'.freeze

      def topics
        Array(document.topics).map(&:values).flatten.map do |topic|
          Comfy::Cms::Block.new(
            identifier: 'topics',
            content: topic,
            processed_content: Mastalk::Document.new(topic).to_html
          )
        end
      end

      def countries_of_delivery
        Array(document.country_search_filter_group).map(&:values).flatten.map do |country|
          country_value = country.gsub(/\d/, '')

          Comfy::Cms::Block.new(
            identifier: 'countries_of_delivery',
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

        content_headers.each do |context_header|
          content = document.send(context_header.field)

          html << context_header.anchor if content.present?
        end

        html << '</ol>'

        content_headers.each do |context_header|
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

      def content_headers
        raise NotImplementedError
      end
    end
  end
end
