require 'algoliasearch'

module Indexers
  module Adapter
    class Algolia < Base
      def create_or_update(objects)
        ::Algolia::Index.new(index_name).add_objects(objects)
      end

      def remove_index
        ::Algolia::Index.new(index_name).delete_index(index_name)
      end
    end
  end
end
