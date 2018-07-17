module Domain
  class << self
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
                    :cms_api_token,
                    :prod_db_url,
                    :dev_db_name,
                    :azure_access_key,
                    :azure_container,
                    :azure_account_name,
                    :cms_public_url

      def initialize
        @public_website_domain = nil
        @public_website_url = nil
        @cms_public_url = nil
        @cms_url = nil
        @cms_api_token = nil
        @prod_db_url = nil
        @dev_db_name = nil
        @azure_access_key = nil
        @azure_container = nil
        @azure_account_name = nil
      end
    end
  end
end

Domain.configure do |config|
  fail "Please set ENV['APP_NAME']" unless Rails.env.production? || ENV['APP_NAME']
  if ENV['APP_NAME'] == 'FINCAP' || ENV['PWD'] == '/srv/fincap-cms'
    config.public_website_domain ||= ENV['FINCAP_PUBLIC_WEBSITE_DOMAIN']
    config.public_website_url    ||= ENV['FINCAP_PUBLIC_WEBSITE_URL']
    config.cms_public_url        ||= ENV['FINCAP_CMS_PUBLIC_URL']
    config.cms_url               ||= ENV['FINCAP_CMS_URL']
    config.cms_api_token         ||= ENV['FINCAP_CMS_API_TOKEN']
    config.prod_db_url           ||= ENV['MAS_FINCAP_CMS_DATABASE_URL']
    config.dev_db_name           ||= 'cms_fincap_development'
    config.azure_access_key      ||= ENV['AZURE_ASSETS_STORAGE_FINCAP_CMS_ACCOUNT_KEY']
    config.azure_container       ||= ENV['AZURE_ASSETS_STORAGE_FINCAP_CMS_CONTAINER']
    config.azure_account_name    ||= ENV['AZURE_ASSETS_STORAGE_FINCAP_CMS_ACCOUNT_NAME']
    config.algolia_app_id        ||= ENV['FINCAP_ALGOLIA_APP_ID']
    config.algolia_api_key       ||= ENV['FINCAP_ALGOLIA_API_KEY']
  else
    config.public_website_domain ||= ENV['MAS_PUBLIC_WEBSITE_DOMAIN']
    config.public_website_url    ||= ENV['MAS_PUBLIC_WEBSITE_URL']
    config.cms_public_url        ||= ENV['MAS_CMS_PUBLIC_URL']
    config.cms_url               ||= ENV['MAS_CMS_URL']
    config.cms_api_token         ||= ENV['MAS_CMS_API_TOKEN']
    config.prod_db_url           ||= ENV['MAS_CMS_DATABASE_URL']
    config.dev_db_name           ||= 'cms_mas_development'
    config.azure_access_key      ||= ENV['AZURE_ASSETS_STORAGE_CMS_ACCOUNT_KEY']
    config.azure_container       ||= ENV['AZURE_ASSETS_STORAGE_CMS_CONTAINER']
    config.azure_account_name    ||= ENV['AZURE_ASSETS_STORAGE_CMS_ACCOUNT_NAME']
    config.algolia_app_id        ||= ENV['ALGOLIA_APP_ID']
    config.algolia_api_key       ||= ENV['ALGOLIA_API_KEY']
  end
end
