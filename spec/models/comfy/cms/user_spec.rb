describe Comfy::Cms::User do
  describe '#email_local_part' do
    it 'returns the local part' do
      subject.email = 'john.doe@example.com'
      expect(subject.email_local_part).to eql('john.doe')
    end
  end
end
