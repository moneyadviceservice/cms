module Cms
  module HippoImporter
    class Base
      attr_reader :data, :site, :parser

      def initialize(data:, docs: [], to: 'en', parser: HippoXmlParser)
        @data = data
        @docs = docs
        @site = Comfy::Cms::Site.find_by(label: to)
        @parser = parser
      end

      def records
        @records ||= parser.parse(data, [hippo_type])
      end

      def hippo_type
        'contentauthoringwebsite:Guide'
      end

      def layout
        @layout ||= site.layouts.find_by(identifier: 'article')
      end

      def parent
        @parent ||= Comfy::Cms::Page.where(parent_id: nil, site: site).first
      end

      def docs
        @cached_docs ||= @docs.empty? ? Comfy::Cms::Page.all.map(&:slug) : @docs
      end

      def next_docs
        @next_docs ||= english? ? docs : docs.map { |a| Comfy::Cms::Page.find_by(slug: a) }.map(&:translation_id)
      end

      def article_id
        english? ? :id : :translation_id
      end

      def import!
        records.select { |r| next_docs.include?(r.send(article_id)) }.map do |record|
          puts "Importing: #{record.id}" unless Rails.env.test?
          page = find_page(record) || Comfy::Cms::Page.new
          content = HippoContent.new(site: site, body: record.body.to_s).to_contento
          blocks = [
            Comfy::Cms::Block.new(identifier: 'content', content: content)
          ]

          import_page(page, record: record, blocks: blocks)
        end
      end

      private

      def import_page(page, record:, blocks:)
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
          p.blocks = blocks
          p.save unless page && page.state == 'published'
        end
      end

      def english?
        site.label == 'en'
      end

      def find_page(record)
        if english?
          Comfy::Cms::Page.where(slug: record.id, site: site).first
        else
          Comfy::Cms::Page.where(translation_id: record.translation_id, site: site).first
        end
      end
    end
  end
end
