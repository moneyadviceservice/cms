module Prismic
  class HTMLConverter
    LIST_ITENS = ['list-item', 'o-list-item']
    HTML_LIST = {
      'list-item' => 'ul',
      'o-list-item' => 'ol'
    }
    attr_reader :content

    def initialize(content)
      fragments = map_fragments(content)
      ordered_fragments = []

      fragments.each_with_index do |fragment, index|
        if fragment.field_type.in?(LIST_ITENS)
          if index.zero? || !fragments[index - 1].field_type.in?(LIST_ITENS)
            ordered_fragments << map_html_list(fragments, fragment, index)
          end
        else
          ordered_fragments << fragment
        end
      end

      @content = ordered_fragments
    end

    def to_html
      content.map do |fragment|
        if fragment.is_a?(Array)
          html = fragment.map { |f| to_tag(f) }.join
          fragment_type = fragment.first.field_type
          "<#{HTML_LIST[fragment_type]}>#{html}</#{HTML_LIST[fragment_type]}>"
        else
          to_tag(fragment)
        end
      end.compact.join
    end

    def to_tag(fragment)
      TagConverter.new(
        document_fragment: fragment.document,
        fragment_type: fragment.field_type,
        text: fragment.text,
        text_format: fragment.format
      ).to_html
    end

    private

    def map_fragments(content)
      content.map do |fragment|
        prismic_fragment = Prismic::Fragment.new(fragment)

        next if prismic_fragment.field_type.blank?

        prismic_fragment
      end.compact
    end

    def map_html_list(fragments, fragment, index)
      list = []
      i = index

      while fragments[i] && fragments[i].field_type.in?(LIST_ITENS)
        list << fragments[i]
        i += 1
      end

      list
    end
  end
end
