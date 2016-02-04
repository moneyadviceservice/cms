describe Comfy::Cms::User do
  describe 'validations' do
    it { should validate_presence_of(:role) }
  end

  describe 'role' do
    it 'allows the role to be set as user' do
      subject.role = Comfy::Cms::User.roles[:user]
      expect(subject.role).to eq('user')
    end

    it 'allows the role to be set as an admin' do
      subject.role = Comfy::Cms::User.roles[:admin]
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
