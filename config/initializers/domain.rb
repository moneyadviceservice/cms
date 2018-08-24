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
      attr_accessor :app_name,
                    :algolia_app_id,
                    :algolia_api_key,
                    :azure_access_key,
                    :azure_account_name,
                    :azure_container,
                    :cms_api_token,
                    :cms_public_url,
                    :cms_url,
                    :dev_db_name,
                    :prod_db_url,
                    :public_website_domain,
                    :public_website_url,
                    :redirect_domain

      def initialize
        @algolia_app_id = nil
        @algolia_api_key = nil
        @azure_access_key = nil
        @azure_account_name = nil
        @azure_container = nil
        @cms_api_token = nil
        @cms_public_url = nil
        @cms_url = nil
        @dev_db_name = nil
        @prod_db_url = nil
        @public_website_domain = nil
        @public_website_url = nil
        @redirect_domain = nil
      end
    end
  end
end

Domain.configure do |config|
  fail "Please set ENV['APP_NAME']" unless Rails.env.production? || ENV['APP_NAME']
  if ENV['APP_NAME'] == 'FINCAP' || ENV['PWD'] == '/srv/fincap-cms'
    config.app_name              ||= 'FINCAP'
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
    config.redirect_domain       ||= ENV['FINCAP_PUBLIC_WEBSITE_DOMAIN']
  else
    config.app_name              ||= 'MAS'
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
    config.redirect_domain       ||= ENV['FARADAY_HOST']
  end
end

puts("=" * 80)
puts("Running '#{Domain.config.app_name}' CMS.")
puts("=" * 80)
