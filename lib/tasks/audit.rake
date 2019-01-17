namespace :audit do
  desc 'Produces a pull of the content data from the CMS as .csv file'
  task pages: :environment do
    Rails.logger = Logger.new(STDOUT)

    pages_count = Cms::Audit::Pages.generate_report
    Rails.logger.info "Generated: #{pages_count} pages"
  end
end
