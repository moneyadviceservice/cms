# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Seeding for site with hostname: #{ENV['HOSTNAME']}   within environment #{Rails.env}"

site_data_en = {
  label: "en",
  identifier: "money-advice-service-en",
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: "en",
  locale: "en",
  is_mirrored: true
}

site_data_cy = {
  label: "cy",
  identifier: "money-advice-service-cy",
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: "cy",
  locale: "en",
  is_mirrored: true
}

puts "Seeding MAS sites..."
site_en = Comfy::Cms::Site.find_or_create_by(site_data_en)
site_cy = Comfy::Cms::Site.find_or_create_by!(site_data_cy)

puts "Seeding categories..."
categories = YAML::load_file("#{Rails.root}/config/categories.yml")
categories.each do |parent, children|
  saved_parent = Comfy::Cms::Category.create!(site: site_en, label: parent, title_en: parent.underscore.humanize, title_cy: parent.underscore.humanize, categorized_type: "Comfy::Cms::Page", navigation: 1)
  children.each { |child| Comfy::Cms::Category.create!(site: site_en, label: child, title_en: child.underscore.humanize, title_cy: child.underscore.humanize, categorized_type: "Comfy::Cms::Page", parent_id: saved_parent.id) }
end

puts "Seeding layouts..."
default_content = <<-END
{{ cms:page:content:rich_text }}
END
%w(article news action_plan tool corporate video).each do |name|
  Comfy::Cms::Layout.find_or_create_by(site: site_en, content: default_content, label: name.titleize, identifier: name)
  Comfy::Cms::Layout.find_or_create_by(site: site_cy, identifier: name).update_attributes!(content: default_content)
end

puts "Seeding MAS users..."
Comfy::Cms::User.create_with(password: 'password', role: 'admin').find_or_create_by!(email: 'user@test.com')

puts 'Creating an example article'
# If we don't do this, we end up in a weird state where because the home_page has
# been created first, then Comfy decides the default layout for future pages should
# also be home_page.
Cms::PageBuilder.add_example_article!

puts 'Adding home page...'
Cms::LayoutBuilder.add_home_page!
Cms::PageBuilder.add_home_page!

puts 'Adding footer...'
Cms::LayoutBuilder.add_footer!
Cms::PageBuilder.add_footer!

puts 'Adding offline page...'
Cms::LayoutBuilder.add_offline_page!
Cms::PageBuilder.add_offline_page!
