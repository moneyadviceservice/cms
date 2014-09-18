# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = YAML::load_file("#{Rails.root}/config/categories.yml")

puts "Seeding for site with hostname: #{ENV['HOSTNAME']}   within environment #{Rails.env}"

site_data = {
  label: "Money Advice Service",
  identifier: "money-advice-service",
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: "cms",
  locale: "en",
  is_mirrored: false
}

puts "Seeding MAS site..."
site = Comfy::Cms::Site.first_or_create(site_data)

puts "Seeding categories..."
categories.each do |parent, children|
  labels = children.nil? ? [parent] : children
  labels.each { |label| Comfy::Cms::Category.create(site_id: site.id, label: label, categorized_type: "Comfy::Cms::Page") }
end

puts "Seeding layouts..."
default_content = <<-END
{{ cms:page:content:rich_text }}
END
Comfy::Cms::Layout.find_or_create_by(site: site, content: default_content, label: "default", identifier: "default")
