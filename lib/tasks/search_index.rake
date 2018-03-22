namespace :search do
  desc 'Index CMS database'
  task :index, [:app, :adapter] => :environment do |_t, args|
    if args[:app].blank?
      fail 'App required. E.g rake search:index[mas] or rake search:index[fincap]'
    end

    adapter = ENV['SEARCH_INDEX_SERVICE']
    app = args[:app]

    Indexers::Category.new(
      collection: Comfy::Cms::Category.all,
      adapter: adapter,
      app: app
    ).index

    Comfy::Cms::Page
      .includes(:blocks)
      .includes(:site)
      .includes(:layout)
      .joins(:layout)
      .where('comfy_cms_layouts.label NOT IN ("News", "Action Plan")')
      .find_in_batches(batch_size: 500) do |pages|
        Indexers::Page.new(
          collection: pages,
          adapter: adapter,
          app: app
        ).index
    end
  end
end

module Indexers
  class Base
    attr_reader :collection, :adapter

    def initialize(collection:, adapter:, app:)
      @collection = collection
      @adapter = Indexers::Adapter.const_get(
        adapter.to_s.capitalize
      ).new(index_name:
        "#{app}_#{self.class.name.demodulize.downcase.pluralize}"
      )
    end

    def index
      adapter.create_or_update(objects)
    end
  end

  class Page < Base
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

  class Category < Base
    def objects
      collection.map do |category|
        [
          add_category(category, locale: 'en'),
          add_category(category, locale: 'cy')
        ]
      end.flatten
    end

    private

    def add_category(category, locale:)
      serializer = CategorySerializer.new(category, scope: locale)
      {
        objectID: "/#{locale}/categories/#{category.label}",
        title: serializer.title,
        description: serializer.description,
        links: serializer.links.as_json
      }
    end
  end

  module Adapter
    class Base
      attr_reader :index_name

      def initialize(index_name:)
        @index_name = index_name
      end
    end

    require 'algoliasearch'
    class Algolia < Base
      def create_or_update(objects)
        puts "Indexing '#{index_name}'. Objects: #{objects.size}."
        index = ::Algolia::Index.new(index_name)
        index.add_objects(objects)
      end
    end

    class Local < Base
      def create_or_update(objects)
        puts "Indexing '#{index_name}'. Objects: #{objects.size}."
        objects.each do |object|
          puts '-' * 80
          puts object
          puts '-' * 80
        end
      end
    end
  end
end
