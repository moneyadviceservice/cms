module Indexers
  class Base
    attr_reader :collection, :adapter
    INDEX_NAME = 'pages'.freeze

    def initialize(collection:, adapter:, adapter_namespace: Indexers::Adapter)
      @collection = collection
      @adapter = adapter_namespace.const_get(adapter.to_s.capitalize).new(
        index_name: index_name
      )
    end

    def index_name
      INDEX_NAME
    end

    def index
      adapter.remove_index
      adapter.create_or_update(objects)
    end

    def objects
      fail(NotImplementedError)
    end
  end
end
