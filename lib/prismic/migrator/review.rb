module Prismic
  module Migrator
    class Review < EvidenceHub
      def layout_identifier
        'review'
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
          data_types
        ].flatten.compact
      end

      def data_types
        if document.review_type.present?
          Comfy::Cms::Block.new(
            identifier: 'data_types',
            content: document.review_type,
            processed_content: Mastalk::Document.new(document.review_type).to_html
          )
        end
      end

      def content_html
        html = '<ol>'

        document.review_sections.each do |review_section|
          next if review_section.blank?

          title = review_section['review_section_title']
          html << %(<li><a href="##{title.parameterize}">#{title}</a></li>)
        end

        html << '</ol>'

        document.review_sections.each do |review_section|
          next if review_section.blank?

          title = review_section['review_section_title']
          html << %(<h2 id="#{title.parameterize}">#{title}</h2>)
          html << Prismic::HTMLConverter.new(
            review_section['review_section_content']
          ).to_html
        end

        if document.links_to_research.present?
          html << '<h2>Full report</h2>'
          html << document.links_to_research
        end

        html
      end
    end
  end
end
