namespace :b2b do
  desc 'Create corporate article type'
  task create_type: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    site = Comfy::Cms::Site.first
    layout = site.layouts.find_or_initialize_by(
      label: 'Corporate Article',
      identifier: 'corporate_article',
      content: "{{ cms:page:content:rich_text }}\n"
    )

    puts("*" * 80)
    puts("Saving ##{layout.identifier} for site ##{site.label} and mirroring to others sites.")
    puts("*" * 80)

    layout.save && puts("Layout saved successfully. Details: \n#{layout.inspect}.\nMirrors: #{layout.mirrors}")
  end
end
