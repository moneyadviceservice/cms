module Cms
  module HippoImporter
    class HippoContent
      attr_accessor :site, :body, :html_decoder

      def initialize(site:, body:)
        @site = site
        @body = body
        @html_decoder = HTMLEntities.new
      end

      def to_contento
        decoded = html_decoder.decode(body)
        html = Nokogiri::HTML.parse(decoded)
        remove_unused_elements(html)
        convert_videos(html)
        ReverseMarkdown.site = site
        ReverseMarkdown.convert(html)
      end

      def remove_unused_elements(html)
        ['//p[@class="intro"]/img', '//a[@class="action-email"]',
         '//form[@class="action-form"]', '//span[@class="collapse"]'].each do |path|
          html.xpath(path).remove
        end
      end

      def convert_videos(html)
        html.xpath('//iframe[starts-with(@src, "https://www.youtube.com/embed")]').each  do |e|
          e.replace('({' + e.attributes['src'].value.gsub('https://www.youtube.com/embed/', '') + '})')
        end
      end
    end
  end
end
