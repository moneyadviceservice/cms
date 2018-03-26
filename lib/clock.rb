require 'clockwork'
require './config/boot'
require './config/environment'
require './lib/cms/publish_scheduled_pages_task'
require './lib/cms/update_page_views_task'

module Clockwork
  Rails.logger = Logger.new(ENV.fetch('LOG_FILE', STDOUT))

  configure do |config|
    config[:logger] = Rails.logger
  end

  every(1.day, 'update_page_views.job', at: '03:00') do
    ::UpdatePageViewsTask.run
  end

  every(1.day, 'publish_scheduled_pages.job', at: '04:00') do
    ::PublishScheduledPagesTask.run
  end

  every(1.day, 'index_database.job', at: '05:00') do
    adapter = ENV.fetch('INDEXERS_ADAPTER')
    ::IndexDatabaseTask.new(adapter).run
  end
end
