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

    def slug
      formatted_title.parameterize
    end

    def filename
      formatted_title[0..30].gsub(/\//, '').parameterize
    end

    def get_binding
      binding
    end

    def migrate
      klass_name = if evidence_type.present?
                     evidence_type
                   else
                     type
                   end

      klass = "Prismic::Migrator::#{klass_name.classify}".constantize

      klass.new(self).migrate
    end
  end
end
