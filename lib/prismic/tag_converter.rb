module Prismic
  class TagConverter
    PRISMIC_FIELD = {
      paragraph: 'p',
      heading1: 'h1',
      heading2: 'h2',
      heading3: 'h3',
      heading4: 'h4',
      heading5: 'h5',
      heading6: 'h6',
      :'list-item' => 'li',
      embed: '',
      image: '',
      :'o-list-item' => 'li'
    }.stringify_keys.freeze

    PRISMIC_FORMAT = {
      strong: 'strong',
      em: 'em'
    }.stringify_keys.freeze
    attr_accessor :fragment
    delegate :field_type, :text, :text_format, to: :fragment
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
      result = convert_special_formats

      "<#{html_tag}>#{result}</#{html_tag}>"
    end

    def html_tag
      PRISMIC_FIELD[field_type].to_s
    end

    private

    # Prismic formats. The "spans" node has this possible values:
    #
    #  ["strong", "hyperlink", "em"]
    #
    def convert_special_formats
      html = text.dup

      text_format.each do |format|
        start_at = format['start']
        end_at = format['end']
        html_tag_format = PRISMIC_FORMAT[format['type']]
        content = text[start_at...end_at]

        next if html_tag_format.blank?

        if html[start_at..end_at] == content
          html[start_at..end_at] = "<#{html_tag_format}>#{content}</#{html_tag_format}>"
        else
          new_start_at = html.index(content)
          new_end_at = new_start_at + (end_at - start_at) - 1
          new_content = html[new_start_at..new_end_at]

          html[new_start_at..new_end_at] =
            "<#{html_tag_format}>#{new_content}</#{html_tag_format}>"
        end
      end

      html
    end
  end
end
