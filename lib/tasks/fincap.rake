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

    layouts = YAML::load_file("#{Rails.root}/config/fincap_layouts.yml")

    layouts.each do |_name , attributes|
      english_site.layouts.find_or_create_by(attributes)
    end
  end
end
