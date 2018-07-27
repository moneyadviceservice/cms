require_relative 'data_store'
require_relative 'cms_converter'
require_relative 'converted_document'
require_relative 'html_converter'
require_relative 'tag_converter'

module Prismic
  class Document < OpenStruct
    extend DataStore
    attr_reader :row, :attributes

    def initialize(row)
      @row = row
      @attributes = row.keys

      super(row)
    end

    def to_cms
      ::Prismic::CmsConverter.new(self).convert
    end
  end
end
