module Prismic
  class CmsDocument < OpenStruct
  end

  class CmsConverter
    attr_reader :document, :converted_data

    def initialize(document)
      @document = document
      @converted_data = {}
    end

    def convert
      document.row.each do |attribute, content|
        if content.is_a?(Array) && content.first.is_a?(Hash)
          converted_data[attribute] = HTMLConverter.new(content).to_html
        else
          converted_data[attribute] = content
        end
      end

      CmsDocument.new(converted_data)
    end
  end
end
