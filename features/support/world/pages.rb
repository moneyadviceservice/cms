module World
  module Pages
    %w(home edit new tags_admin user_management sign_in).each do |page|
      define_method("#{page}_page") do
        "UI::Pages::#{page.camelize}".constantize.new
      end
    end
  end
end

World(World::Pages)
