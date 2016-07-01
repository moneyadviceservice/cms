module MAS
  def self.env
    @env ||= ActiveSupport::StringInquirer.new(
      ENV['MAS_ENVIRONMENT'] || 'development'
    )
  end
end

