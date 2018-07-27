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
          )
        ]
      end
    end
  end
end
