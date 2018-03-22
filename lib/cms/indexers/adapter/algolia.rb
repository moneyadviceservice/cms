require 'algoliasearch'

module Indexers
  module Adapter
    class Algolia < Base
      def create_or_update(objects)
        ::Algolia::Index.new(index_name).add_objects(objects)
      end
    end
  end
end
