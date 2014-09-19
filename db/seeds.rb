# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = YAML::load_file("#{Rails.root}/config/categories.yml")

puts "Seeding for site with hostname: #{ENV['HOSTNAME']}   within environment #{Rails.env}"

site_data_en = {
  label: "en",
  identifier: "money-advice-service-en",
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: "cms/en",
  locale: "en",
  is_mirrored: true
}

site_data_cy = {
  label: "cy",
  identifier: "money-advice-service-cy",
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: "cms/cy",
  locale: "en",
  is_mirrored: true
}

puts "Seeding MAS sites..."
site_en = Comfy::Cms::Site.find_or_create_by!(site_data_en)
site_cy = Comfy::Cms::Site.find_or_create_by!(site_data_cy)

puts "Seeding categories..."
categories.each do |parent, children|
  labels = children.nil? ? [parent] : children
  labels.each { |label| Comfy::Cms::Category.create(site_id: site_en.id, label: label, categorized_type: "Comfy::Cms::Page") }
end

puts "Seeding layouts..."
default_content = <<-END
{{ cms:page:content:rich_text }}
END
Comfy::Cms::Layout.find_or_create_by(site: site_en, content: default_content, label: "default", identifier: "default")
Comfy::Cms::Layout.find_by(site_id: site_cy.id).update_attributes!(content: default_content)
