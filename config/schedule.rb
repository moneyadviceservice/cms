every 1.day, :at => '3:00 am' do
  rake "cms:update_page_views"
end
