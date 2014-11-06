module World
  module Pages
    %w(edit home new files_admin files_new sign_in tags_admin user_management).each do |page|
      define_method("#{page}_page") do
        "UI::Pages::#{page.camelize}".constantize.new
      end
    end
  end
end

World(World::Pages)
