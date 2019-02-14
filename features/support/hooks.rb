After do |scenario|
  if scenario.failed?
    timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')
    suffix    = "%04X" % rand(65536)
    name      = scenario.name[0..20].downcase.gsub(/\W/, '-')
    filename  = File.join(Dir.tmpdir, "#{name}-#{timestamp}-#{suffix}")
    saved_image = save_screenshot("#{filename}.png")
    unless saved_image.empty?
      puts "saved screenshot for scenario \"#{scenario.name}\" to #{saved_image}"
    end
    saved_page = save_page("#{filename}.html")
    unless saved_page.empty?
      puts "saved page for scenario \"#{scenario.name}\" to #{saved_page}"
    end
    
    # Tell Cucumber to quit after this scenario is done - if it failed. 
    Cucumber.wants_to_quit = true 
  end
end

After '@categories_admin' do |scenario|
  DatabaseCleaner.clean
end
