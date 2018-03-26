module Indexers
  class Page < ::Indexers::Base
    def objects
      collection.map do |page|
        serializer = PageSerializer.new(page)

        {
          objectID: serializer.full_path,
          title: serializer.label,
          description: serializer.meta_description,
          published_at: serializer.published_at
        }
      end
    end
  end
end
