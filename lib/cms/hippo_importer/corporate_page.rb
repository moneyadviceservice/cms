module Cms
  module HippoImporter
    class CorporatePage < HippoImporter::Base
      def hippo_type
        'contentauthoringwebsite:Guide'
      end

      def layout
        @_layout ||= site.layouts.find_by(identifier: 'corporate_page')
      end
    end
  end
end