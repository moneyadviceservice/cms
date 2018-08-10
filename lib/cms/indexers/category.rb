module Indexers
  class Category < Base
    LOCALES = %w[en cy].freeze

    def objects
      collection.map do |category|
        LOCALES.map { |locale| add_category(category, locale: locale) }
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
end
