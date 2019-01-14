namespace :audit do
  task pages: :environment do
    Audit::Pages.generate_report
  end
end

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

    def self.generate_report
      new(all).generate
    end

    def initialize(pages)
      @pages = pages.map { |page| PageSerializer.new(page) }
    end

    def generate
      CSV.open('audit.csv', 'wb') do |csv|
        csv << HEADERS
        @pages.map do |page|
          csv << [
            page.label,
            page.full_path,
            page.layout_identifier,
            page.category_names,
            page.tags,
            page.meta_description,
            page.meta_title,
            page.object.meta_keywords,
            page.object.suppress_from_links_recirculation,
            page.object.regulated,
            page.supports_amp,
            I18n.l(page.object.updated_at, format: :date_with_time),
            ActivityLog.fetch(from: page.object).first.try(:author),
            page.object.state
          ]
        end
      end
    end
  end
end
