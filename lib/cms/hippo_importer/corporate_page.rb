module Cms
  module HippoImporter
    class CorporatePage < HippoImporter::Base
      def hippo_type
        'contentauthoringwebsite:Guide'
      end

      def layout
        @layout ||= site.layouts.find_by(identifier: 'corporate_article')
      end
    end
  end
end
