module API
  class AuthenticationFilter
    MAS_CMS_API_TOKEN = Domain.config.cms_api_token

    def self.before(controller)
      authenticate?(controller)
    end

    def self.authenticate?(controller)
      controller.authenticate_or_request_with_http_token do |token, _|
        ::Digest::SHA256.hexdigest(MAS_CMS_API_TOKEN) ==
          ::Digest::SHA256.hexdigest(token)
      end
    end
  end
end
