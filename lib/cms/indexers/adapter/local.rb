require 'terminal-table'

module Indexers
  module Adapter
    class Local < Base
      HEADINGS = %w[Field Value].freeze
      STYLE = { width: 100 }.freeze

      def create_or_update(objects)
        @table = Terminal::Table.new(
          title: "Index: #{index_name} - #{objects.size} number of indices",
          headings: HEADINGS,
          style: STYLE
        )

        objects.each do |object|
          object.each do |key, value|
            @table.add_row [key, value.to_s.truncate(80)]
          end
          @table.add_separator
        end

        Rails.logger.info(@table)
      end
    end
  end
end
