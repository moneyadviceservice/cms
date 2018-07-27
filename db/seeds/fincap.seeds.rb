Dir[File.join(Rails.root, 'db', 'seeds', 'fincap_data', '*.rb')].each do |seed|
  load seed
end

Comfy::Cms::User.create_with(password: 'password', role: 'admin').find_or_create_by!(email: 'user@test.com')
