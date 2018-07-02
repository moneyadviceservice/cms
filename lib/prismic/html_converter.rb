module Prismic
  class HTMLConverter
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def to_html
      content.each_with_index.map do |fragment, index|
        fragment_type = fragment['type']

        next if fragment_type.blank?

        text = fragment['content']['text']
        text_format = fragment['content']['spans']
        document_fragment = Nokogiri::HTML::DocumentFragment.parse(text)

        TagConverter.new(
          document_fragment: document_fragment,
          fragment_type: fragment_type,
          text: text,
          text_format: text_format
        ).to_html
      end.compact.join
    end
  end
end
