module Cms
  module Audit
    class Pages
      PAGE_TYPES = ['article', 'corporate', 'video']
      HEADERS = [
        'Page title',
        'URL',
        'Page type',
        'Categories',
        'Tags',
        'Meta description',
        'Meta title',
        'Site search keywords',
        'Suppress from links recirculation',
        'Regulated content',
        'Supports AMP',
        'Last edited',
        'Last edited by',
        'Status'
      ]

      def self.all
        Comfy::Cms::Page
          .joins(:layout)
          .where(
            comfy_cms_layouts: { identifier: PAGE_TYPES }
          )
      end

      def self.generate_report(file: '/tmp/audit.csv')
        new(all).generate(file)
      end

      def initialize(pages)
        # @pages = pages
        @pages = pages.map { |page| PageSerializer.new(page) }
      end

      def generate(file)
        CSV.open(file, 'wb') do |csv|
          csv << HEADERS
          @pages.map do |page|
            page_obj = page.object
            csv << [
              page_obj.label,
              page_obj.full_path,
              page_obj.layout_identifier,
              page_obj.category_names,
              page_obj.keywords.map { |keyword| keyword.value },
              page_obj.meta_description,
              page_obj.meta_title,
              page_obj.meta_keywords,
              page_obj.suppress_from_links_recirculation,
              page_obj.regulated,
              page_obj.supports_amp,
              I18n.l(page_obj.updated_at, format: :date_with_time),
              ActivityLog.fetch(from: page_obj).first.try(:author),
              page_obj.state
            ]
          end
        end
        @pages.count
      end
    end
  end
end

