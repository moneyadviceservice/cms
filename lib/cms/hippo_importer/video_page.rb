module Cms
  module HippoImporter
    class VideoPage < HippoImporter::Base
      def hippo_type
        'contentauthoringwebsite:VideoPage'
      end

      def layout
        @layout ||= site.layouts.find_by(identifier: 'video')
      end
    end
  end
end
