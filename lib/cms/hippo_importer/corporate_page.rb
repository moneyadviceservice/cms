module Cms
  module HippoImporter
    class CorporatePage < HippoImporter::Base
      def hippo_type
        'contentauthoringwebsite:StaticPage'
      end

      def layout
        @layout ||= site.layouts.find_by(identifier: 'corporate')
      end
    end
  end
end
