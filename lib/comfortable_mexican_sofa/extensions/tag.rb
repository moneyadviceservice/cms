# MONKEY PATCH

module ComfortableMexicanSofa
  module Extensions
    module Tag
      # rubocop:disable Style/PredicateName
      def is_cms_block?
        %w(page field collection simple image).member?(self.class.to_s.demodulize.underscore.split(/_/).first)
      end
    end
  end
end

ComfortableMexicanSofa::Tag::InstanceMethods.send :prepend, ComfortableMexicanSofa::Extensions::Tag
