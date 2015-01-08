module Cms
  module HippoImporter
    class Base
      def initialize(data:, docs:, to:, parser: HippoXmlParser, html_decoder: HTMLEntities.new)
        @records = parser.parse(data, [hippo_type])
        @_site = site || 'en'
        @docs = docs || []
        @html_decoder = html_decoder
      end

      attr_reader :records, :html_decoder

      def site
        @site ||= Comfy::Cms::Site.find_by(label: @_site)
      end

      def hippo_type
        'contentauthoringwebsite:Guide'
      end

      def layout
        @_layout ||= (site.try(:layouts) || []).first
      end

      def parent
        @_parent ||= Comfy::Cms::Page.where(parent_id: nil, site: site).first
      end

      def decoded(str)
        decoded = html_decoder.decode(str)
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

      def docs
        @cached_docs ||= @docs.empty? ? Comfy::Cms::Page.all.map(&:slug) : @docs
      end

      def next_docs
        @next_docs ||= @_site == 'en' ? docs : docs.map { |a| Comfy::Cms::Page.find_by(slug: a) }.map(&:translation_id)
      end

      def article_id
        @_site == 'en' ? :id : :translation_id
      end

      def import!
        records.select { |r| next_docs.include?(r.send(article_id)) }.map do |record|
          puts "Importing: #{record.id}"
          page = find_page(record) || Comfy::Cms::Page.new

          page.tap do |p|
            p.site = site
            p.layout = layout
            p.parent = parent
            p.label = record.title
            p.slug = record.id
            p.created_at = record.created_at
            p.updated_at = record.updated_at
            p.meta_description = record.meta_description.present? ? record.meta_description : record.preview
            p.meta_title = record.title_tag
            p.state = 'draft'
            p.translation_id = record.translation_id
            p.blocks = [
              Comfy::Cms::Block.new(identifier: 'content', content: decoded(record.body.to_s))
            ]
            p.save unless page && page.state == 'published'
          end
        end
      end

      private

      def find_page(record)
        if @_site == 'en'
          Comfy::Cms::Page.where(slug: record.id, site: site).first
        else
          Comfy::Cms::Page.where(translation_id: record.translation_id, site: site).first
        end
      end
    end
  end
end
