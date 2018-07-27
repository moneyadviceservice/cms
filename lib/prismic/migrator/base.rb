module Prismic
  module Migrator
    class Base
      PUBLISHED = 'published'.freeze
      attr_reader :document

      delegate :formatted_title, :slug, to: :document

      def initialize(document)
        @document = document
      end

      def migrate
        site.pages.create!(
          label: formatted_title,
          slug: slug,
          layout: layout,
          state: PUBLISHED,
          blocks: blocks
        )
      end

      def layout
        Comfy::Cms::Layout.find_by(identifier: layout_identifier)
      end

      def layout_identifier
        raise NotImplementedError
      end

      def blocks
        raise NotImplementedError
      end

      def site
        Comfy::Cms::Site.find_by(label: 'en')
      end
    end
  end
end
