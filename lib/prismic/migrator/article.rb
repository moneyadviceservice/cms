module Prismic
  module Migrator
    class Article < Base
      def layout_identifier
        'article'
      end

      def blocks
        [
          Comfy::Cms::Block.new(
            identifier: 'content',
            content: document.content_markdown,
            processed_content: document.content
          ),
          hero_description
        ].flatten.compact
      end

      def hero_description
        if document.title.present?
          Comfy::Cms::Block.new(
            identifier: 'component_hero_description',
            content: document.formatted_title,
            processed_content: document.formatted_title
          )
        end
      end
    end
  end
end
