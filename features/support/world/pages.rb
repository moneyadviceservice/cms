module World
  module Pages
    Dir["features/support/ui/pages/*.rb"].each do |page|
      page = page.split("/").last.gsub('.rb', '')
      define_method("#{page}_page") do
        "UI::Pages::#{page.camelize}".constantize.new
      end
    end
  end
end

World(World::Pages)
