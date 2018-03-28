module Indexers
  class Page < ::Indexers::Base
    CONTENT_IDENTIFIER = 'content'.freeze

    # Algolia has a validation for every attribute
    # The 7000 characters was decided to gives us breathing
    # room for the 10_000 bytes validation.
    #
    MAX_CONTENT_SIZE = 7_000

    def objects
      collection.map do |page|
        serializer = PageSerializer.new(page)

        {
          objectID: serializer.full_path,
          title: serializer.label,
          description: serializer.meta_description,
          content: content_for(serializer),
          published_at: serializer.published_at
        }
      end
    end

    private

    def content_for(serializer)
      content = serializer.blocks.find do |block|
        block.identifier == CONTENT_IDENTIFIER
      end.try(:processed_content)

      content[0..MAX_CONTENT_SIZE]
    end
  end
end
