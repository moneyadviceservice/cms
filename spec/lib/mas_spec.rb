describe MAS do
  before do
    @old_mas_environment = ENV['MAS_ENVIRONMENT']
  end

  after do
    ENV['MAS_ENVIRONMENT'] = @old_mas_environment
  end

  it 'allows us to inquire on the value of MAS_ENVIRONMENT' do
    ENV['MAS_ENVIRONMENT'] = 'foo'
    expect(MAS.env.foo?).to be_truthy
  end

  it 'defaults to development environment' do
    ENV['MAS_ENVIRONMENT'] = nil
    MAS.env.development?
  end
end
