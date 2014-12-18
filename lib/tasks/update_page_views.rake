require_relative '../cms/update_page_views_task'

namespace :cms do
  desc 'Updates articles page views from Google Analytics'
  task update_page_views: :environment do
    UpdatePageViewsTask.run
  end
end
