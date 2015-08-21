class EnvironmentDetective
  def environment
    development? || test? || qa? || production? || default_environment
  end

  private

  def default_environment
    'production'
  end

  def development?
    'development' if Rails.env.development?
  end

  def test?
    'test' if Rails.env.test?
  end

  def qa?
    'qa' if ENV['MAS_ENVIRONMENT'] == 'qa'
  end

  def production?
    'production' if ENV['MAS_ENVIRONMENT'] == 'production'
  end
end

environment = EnvironmentDetective.new.environment
repo = Feature::Repository::YamlRepository.new("#{Rails.root}/config/feature_toggles/#{environment}.yml")
Feature.set_repository repo
