# MONKEY PATCH

module ComfortableMexicanSofa
  module Tag
    def is_cms_block?
      %w(page field collection image).member?(self.class.to_s.demodulize.underscore.split(/_/).first)
    end
  end
end
