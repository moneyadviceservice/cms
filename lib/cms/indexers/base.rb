module Indexers
  class Base
    attr_reader :collection, :adapter, :index_name

    def initialize(collection:, adapter:, adapter_namespace: Indexers::Adapter)
      @collection = collection
      @index_name = "#{self.class.name.demodulize.downcase.pluralize}"
      @adapter = adapter_namespace.const_get(adapter.to_s.capitalize).new(
        index_name: index_name
      )
    end

    def index
      adapter.create_or_update(objects)
    end

    def objects
      fail(NotImplementedError)
    end
  end
end
