module Prismic
  class TagConverter
    PRISMIC_FIELD = {
      paragraph: '<p/>',
      heading1: '<h1/>',
      heading2: '<h2/>',
      heading3: '<h3/>',
      heading4: '<h4/>',
      heading5: '<h5/>',
      heading6: '<h6/>',
      :'list-item' => '<li/>',
      embed: '',
      image: '',
      :'o-list-item' => '<li/>'
    }.stringify_keys.freeze

    PRISMIC_FORMAT = {
      strong: 'strong',
      em: 'em'
    }.stringify_keys.freeze
    attr_accessor :document_fragment, :fragment_type, :text, :text_format
    include ActiveModel::Model

    # Transform Prismic fields into html tags. The possible values:
    #  [
    #   "paragraph",
    #   "list-item",
    #   "embed",
    #   "image",
    #   "o-list-item",
    #   "heading2",
    #   "heading3",
    #   "heading4",
    #   "heading1",
    #   "heading6",
    #   "heading5"
    #  ]
    #
    def to_html
      html_tag = PRISMIC_FIELD[fragment_type].to_s

      fragment_text.wrap(html_tag) if html_tag

      convert_special_formats(
        text: text,
        text_format: text_format
      )

      document_fragment.to_html
    end

    private

    def fragment_text
      document_fragment.xpath('.//text()')
    end

    # Prismic formats. The "spans" node has this possible values:
    #
    #  ["strong", "hyperlink", "em", "label"]
    #
    def convert_special_formats(text:, text_format:)
      text_format.each do |format|
        start_at = format['start']
        end_at = format['end']
        html_tag_format = PRISMIC_FORMAT[format['type']]
        content = text[start_at, end_at]

        if html_tag_format
          if fragment_text.size > 1
            fragment_text.find { |f| f.text.include?(content) }.replace(
              content.gsub(content, "<#{html_tag_format}>#{content}</#{html_tag_format}>")
            )
          else
            fragment_text.find { |f| f.text.include?(content) }.replace(
              text.gsub(content, "<#{html_tag_format}>#{content}</#{html_tag_format}>")
            )
          end
        end
      end
    end
  end
end
