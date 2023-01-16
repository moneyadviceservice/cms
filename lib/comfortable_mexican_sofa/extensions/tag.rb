# MONKEY PATCH

module ComfortableMexicanSofa
  module Extensions
    module Tag
      MAS_CMS_BLOCKS = %w(page field collection simple image datetime).freeze

      # rubocop:disable Naming/PredicateName
      def is_cms_block?
        MAS_CMS_BLOCKS.member?(
          self.class.to_s.demodulize.underscore.split(/_/).first
        )
      end
    end
  end
end

ComfortableMexicanSofa::Tag::InstanceMethods.prepend ComfortableMexicanSofa::Extensions::Tag
