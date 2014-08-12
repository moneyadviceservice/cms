# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = YAML::load_file("#{Rails.root}/config/categories.yml")

site = Comfy::Cms::Site.create(
  label: "Money Advice Service",
  identifier: "money-advice-service",
  hostname: "cms.dev",
  path: "cms",
  locale: "en",
  is_mirrored: false) if Rails.env == "development"

categories.each do |parent, children|
  labels = children.nil? ? [parent] : children
  labels.each { |label| Comfy::Cms::Category.create(site_id: site.id, label: label, categorized_type: "Comfy::Cms::Page") }
end
