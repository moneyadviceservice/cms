describe Comfy::Cms::User do
  describe 'validations' do
    it { should validate_presence_of(:role) }
  end

  describe 'role' do
    it 'allows the role to be set as a "user"' do
      subject.role = 0
      expect(subject.role).to eq('user')
    end

    it 'allows the role to be set as an admin' do
      subject.role = 1
      expect(subject.role).to eq('admin')
    end
  end

  describe '#email_local_part' do
    it 'returns the local part' do
      subject.email = 'john.doe@example.com'
      expect(subject.email_local_part).to eql('john.doe')
    end
  end
end
