module Indexers
  module Adapter
    class Base
      attr_reader :index_name

      def initialize(index_name:)
        @index_name = index_name
      end
    end
  end
end
