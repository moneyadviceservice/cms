namespace :fincap do
  desc 'Setup fincap data'
  task setup: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    Comfy::Cms::User.create_with(password: 'password', role: 'admin').find_or_create_by!(email: 'user@test.com')

    english_site = Comfy::Cms::Site.find_or_create_by(
      label: 'en',
      identifier: 'money-advice-service-en',
      hostname: ENV['HOSTNAME'] || 'localhost:3000',
      path: 'en',
      locale: 'en',
      is_mirrored: true
    )

    %w(insight).each do |layout|
      english_site.layouts.find_or_create_by(
        identifier: layout,
        label: layout.titleize,
        content: '{{ cms:page:content:rich_text }}'
      )
    end
  end
end
