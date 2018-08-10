# MONKEY PATCH

module ComfortableMexicanSofa
  module Extensions
    module Tag
      MAS_CMS_BLOCKS = %w[page field collection simple image datetime].freeze

      def is_cms_block? # rubocop:disable Style/PredicateName
        MAS_CMS_BLOCKS.member?(
          self.class.to_s.demodulize.underscore.split(/_/).first
        )
      end
    end
  end
end

ComfortableMexicanSofa::Tag::InstanceMethods.send :prepend, ComfortableMexicanSofa::Extensions::Tag
