require 'clockwork'
require './config/boot'
require './config/environment'
require './lib/cms/update_page_views_task'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'update_page_views.job', at: '03:00') do
    ::UpdatePageViewsTask.run
  end
end
