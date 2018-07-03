class Domain
    # Modify Domain configuration
    # Example:
    #   Domain.configure do |config|
    #     config.cms_url = 'localhost:3000'
    #   end
    def configure
      yield configuration
    end

    # Accessor for Domain::Configuration
    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration

  class Configuration
    attr_accessor :public_website_domain,
                  :public_website_url,
                  :cms_url,
                  :cms_api_token

    def initialize
      @public_website_domain = nil
      @public_website_url = nil
      @cms_url = nil
      @cms_api_token = nil
    end
  end

end

Domain.configure do |config|
  if Rails.env.production?
    if ENV['PWD'] == '/srv/fincap-cms'
      config.public_website_domain = ENV['FINCAP_PUBLIC_WEBSITE_DOMAIN']
      config.public_website_url = ENV['FINCAP_PUBLIC_WEBSITE_URL']
      config.cms_url = ENV['FINCAP_CMS_URL']
      config.cms_api_token = ENV['FINCAP_CMS_API_TOKEN']
    else
      config.public_website_domain = ENV['MAS_PUBLIC_WEBSITE_DOMAIN']
      config.public_website_url = ENV['MAS_PUBLIC_WEBSITE_URL']
      config.cms_url = ENV['MAS_CMS_URL']
      config.cms_api_token = ENV['MAS_CMS_API_TOKEN']
    end
  else
    fail "Please set ENV['APP_NAME']" unless ENV['APP_NAME']
    if ENV['APP_NAME'] == 'FINCAP'
      config.public_website_domain = ENV['FINCAP_PUBLIC_WEBSITE_DOMAIN']
      config.public_website_url = ENV['FINCAP_PUBLIC_WEBSITE_URL']
      config.cms_url = ENV['FINCAP_CMS_URL']
      config.cms_api_token = ENV['FINCAP_CMS_API_TOKEN']
    end
    if ENV['APP_NAME'] == 'MAS'
      config.public_website_domain = ENV['MAS_PUBLIC_WEBSITE_DOMAIN']
      config.public_website_url = ENV['MAS_PUBLIC_WEBSITE_URL']
      config.cms_url = ENV['MAS_CMS_URL']
      config.cms_api_token = ENV['MAS_CMS_API_TOKEN']
    end
  end
end
# if ENV['PWD'] == 'MAS'
#   ENV['MAS_PUBLIC_WEBSITE_DOMAIN']
#   ENV['MAS_PUBLIC_WEBSITE_URL']
#   ENV['MAS_CMS_URL']
#   ENV['MAS_CMS_API_TOKEN']
# end

# if ENV['PWD'] == 'FINCAP'
#   ENV['FINCAP_PUBLIC_WEBSITE_DOMAIN']
#   ENV['FINCAP_PUBLIC_WEBSITE_URL']
#   ENV['FINCAP_CMS_URL']
#   ENV['FINCAP_CMS_API_TOKEN']
# end

# if ENV['APP_NAME'] == 'FINCAP'
# # #DATABASES
# # 'fincap_cms_development'
# # 'mas_cms_development'
# # ENV["MAS_CMS_DATABASE_URL"]
# # ENV["FINCAP_CMS_DATABASE_URL"]


# begin

#   # Domain.new
# rescue RuntimeError => e
#   puts e.message
#   exit(1)
# end
