module MAS
  def self.env
    ActiveSupport::StringInquirer.new(ENV['MAS_ENVIRONMENT'] || 'development')
  end
end
