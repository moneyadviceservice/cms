module Prismic
  class CmsConverter
    attr_reader :document, :converted_data

    def initialize(document)
      @document = document
      @converted_data = {}
    end

    def convert
      document.row.each do |attribute, content|
        if content.is_a?(Array) && content.first.is_a?(Hash)
          html = HTMLConverter.new(content).to_html
          converted_data[attribute] = html
          converted_data["#{attribute}_markdown"] = ReverseMarkdown.convert(html)
        else
          converted_data[attribute] = content
        end
      end

      ConvertedDocument.new(converted_data)
    end
  end
end
