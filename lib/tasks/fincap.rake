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

  desc 'Fix Evidence Summaries created_at'
  task fix_evidence_summaries_created_at: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.connection.execute(<<-SQL
      UPDATE
        comfy_cms_pages pages
        INNER JOIN comfy_cms_blocks blocks
          ON blocks.blockable_id = pages.id
          AND blocks.blockable_type = 'Comfy::Cms::Page'
        INNER JOIN comfy_cms_layouts layouts
          ON layouts.id = pages.layout_id
      SET
        pages.created_at = CONCAT(blocks.content, '-01-01 00:00:0')
      WHERE
        layouts.identifier IN ('evaluation', 'insight', 'review')
        AND blocks.identifier = 'year_of_publication'
        AND blocks.content IS NOT NULL
        AND blocks.content != ''
        AND blocks.content < '2018'
    SQL
    )
  end
end
