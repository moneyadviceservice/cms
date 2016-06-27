describe MAS do
  before do
    MAS.class_eval { @env = nil }
  end

  it 'allows us to inquire on the value of MAS_ENVIRONMENT' do
    allow(ENV).to receive(:[]).with('MAS_ENVIRONMENT') { 'foo' }
    expect(MAS.env.foo?).to be_truthy
  end

  it 'defaults to development environment' do
    allow(ENV).to receive(:[]).with('MAS_ENVIRONMENT') { nil }
    MAS.env.development?
  end
end
