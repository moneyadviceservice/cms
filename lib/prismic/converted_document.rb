require 'erb'

module Prismic
  class ConvertedDocument < OpenStruct
    include ActionView::Helpers::SanitizeHelper
    attr_reader :attributes

    def initialize(fields)
      @attributes = fields.keys

      super(fields)
    end

    def formatted_title
      strip_tags(title).to_s
    end

    def filename
      formatted_title[0..30].gsub(/\//, '').parameterize
    end

    def get_binding
      binding
    end

    def migrate
      "Prismic::Migrator::#{type.classify}".constantize.new(self).migrate
    end
  end
end
