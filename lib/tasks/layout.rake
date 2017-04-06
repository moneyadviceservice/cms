namespace :layout do
  desc 'Create layouts in english and welsh for a given name ie rake layout:create["Universal-credit"]'
  task :create, [:name] => :environment do |t, args|
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    content = "{{ cms:page:content:rich_text }}\n"
    identifier = args[:name].downcase
    en_site = Comfy::Cms::Site.find_by(label: 'en')
    cy_site = Comfy::Cms::Site.find_by(label: 'cy')
    en_layout = en_site.layouts.find_or_initialize_by(
      label:      args[:name].humanize,
      identifier: identifier,
      content:    content
    )
    en_layout.save!
    cy_site.layouts.find_by(identifier: identifier).update_attributes!(content: content)
  end
end
