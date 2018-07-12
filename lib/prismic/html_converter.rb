module Prismic
  class Fragment
    attr_reader :field_type, :text, :format

    def initialize(fragment)
      @field_type = fragment['type']
      @text = fragment['content']['text'] if fragment['content']
      @format = fragment['content']['spans'] if fragment['content']
    end

    def document
      Nokogiri::HTML::DocumentFragment.parse(text)
    end
  end

  class HTMLConverter
    LIST_ITENS = ['list-item', 'o-list-item']
    attr_reader :content

    def initialize(content)
      fragments = content.map do |fragment|
        prismic_fragment = Prismic::Fragment.new(fragment)

        next if prismic_fragment.field_type.blank?

        prismic_fragment
      end.compact

      ordered_fragments = []

      fragments.each_with_index do |fragment, index|
        if fragment.field_type.in?(LIST_ITENS)
          if index.zero? || !fragments[index - 1].field_type.in?(LIST_ITENS)

            list = []
            i = index

            while fragments[i] && fragments[i].field_type.in?(LIST_ITENS)
              list << fragments[i]
              i += 1
            end
            ordered_fragments << list
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
          "<ul>#{html}</ul>"
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
  end
end
