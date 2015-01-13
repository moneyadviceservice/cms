namespace :layout do
  desc 'Create layouts'
  task video: :environment do
    content = "{{ cms:page:content:rich_text }}\n"
    en_site = Comfy::Cms::Site.find_by(label: 'en')
    cy_site = Comfy::Cms::Site.find_by(label: 'cy')
    en_layout = en_site.layouts.find_or_initialize_by(
      label: 'Video',
      identifier: 'video',
      content: content
    )
    en_layout.save!
    cy_site.layouts.find_by(identifier: 'video').update_attributes!(content: content)
  end
end
