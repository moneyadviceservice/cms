# MONKEY PATCH

module ComfortableMexicanSofa
  module Extensions
    module Tag
      module ClassMethods
        ComfortableMexicanSofa::Tag.send(:attr_accessor, :required)

        def initialize_tag(blockable, tag_signature, required = false)
          required ||= /\{\{\s*cms:.*(:required)\s*\}\}/ === tag_signature
          super(blockable, tag_signature.gsub(/:required/, '')).tap do |tag|
            if tag && required
              tag.required = required
              tag_signature.gsub!(/:required/, '')
            end
          end
        end
      end

      module InstanceMethods
        MAS_CMS_BLOCKS = %w(page field collection simple image datetime).freeze

        # rubocop:disable Style/PredicateName
        def is_cms_block?
          MAS_CMS_BLOCKS.member?(
            self.class.to_s.demodulize.underscore.split(/_/).first
          )
        end
      end
    end
  end
end

ComfortableMexicanSofa::Tag.extend ComfortableMexicanSofa::Extensions::Tag::ClassMethods
ComfortableMexicanSofa::Tag.prepend ComfortableMexicanSofa::Extensions::Tag::InstanceMethods

ComfortableMexicanSofa::Tag.tag_classes.each do |tag_class|
  tag_class.extend ComfortableMexicanSofa::Extensions::Tag::ClassMethods
  tag_class.prepend ComfortableMexicanSofa::Extensions::Tag::InstanceMethods
end
