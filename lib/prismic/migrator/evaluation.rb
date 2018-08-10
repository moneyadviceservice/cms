module Prismic
  module Migrator
    class Evaluation < EvidenceHub
      def layout_identifier
        'evaluation'
      end

      def content_headers
        [
          OpenStruct.new(
            field: 'description_of_the_programme',
            anchor: '<li><a href="#description">Description of the programme</a></li>',
            heading: '<h2 id="description">Description of the programme</h2>'
          ),
          OpenStruct.new(
            field: 'the_study',
            anchor: '<li><a href="#the-study">The study</a></li>',
            heading: '<h2 id="the-study">The study</h2>'
          ),
          OpenStruct.new(
            field: 'what_are_the_outcomes',
            anchor: '<li><a href="#effective">What are the outcomes?</a></li>',
            heading: '<h2 id="effective">What are the outcomes?</h2>'
          ),
          OpenStruct.new(
            field: 'key_findings',
            anchor: '<li><a href="#key-findings">Key findings</a></li>',
            heading: '<h2 id="key-findings">Key findings</h2>'
          ),
          OpenStruct.new(
            field: 'NEW_what_are_the_costs',
            anchor: '<li><a href="#costs">What are the costs?</a></li>',
            heading: '<h2 id="costs">What are the costs?</h2>'
          ),
          OpenStruct.new(
            field: 'points_to_consider',
            anchor: '<li><a href="#points">Points to consider</a></li>',
            heading: '<h2 id="points">Points to consider</h2>'
          )
        ]
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
          Comfy::Cms::Block.new(
            identifier: 'activities_and_setting',
            content: document.NEW_delivery_channel_markdown,
            processed_content: document.NEW_delivery_channel
          ),
          Comfy::Cms::Block.new(
            identifier: 'programme_delivery',
            content: document.programme_delivery,
            processed_content: document.programme_delivery
          ),
          countries_of_delivery,
          topics,
          client_groups,
          data_types,
          measured_outcomes
        ].compact.flatten
      end

      def data_types
        {
          programme_theory: 'Programme Theory',
          'measured_outcomes_yes/no': 'Measured Outcomes',
          causality: 'Causality',
          process_evaluation: 'Process Evaluation',
          value_for_money: 'Value for money'
        }.map do |prismic_field, cms_value|
          prismic_value = document.send(prismic_field)

          next unless prismic_value == 'Yes'

          Comfy::Cms::Block.new(
            identifier: 'data_types',
            content: cms_value,
            processed_content: Mastalk::Document.new(cms_value).to_html
          )
        end.compact
      end

      def measured_outcomes
        Array(document.NEW_measured_outcomes).map(&:values).flatten.map do |outcome|
          Comfy::Cms::Block.new(
            identifier: 'measured_outcomes',
            content: outcome,
            processed_content: Mastalk::Document.new(outcome).to_html
          )
        end
      end
    end
  end
end
