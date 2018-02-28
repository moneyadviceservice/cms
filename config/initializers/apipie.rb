Apipie.configure do |config|
  config.app_name                = "Cms"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.default_locale          = 'en'
  config.languages               = ['en']
end
