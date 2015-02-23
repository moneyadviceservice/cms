module Cms
  module HippoImporter
    class Tool < HippoImporter::Base
      def hippo_type
        'contentauthoringwebsite:ToolPage'
      end

      def layout
        @layout ||= site.layouts.find_by(identifier: 'tool')
      end
    end
  end
end
