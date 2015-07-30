describe RedirectVersion do
  let(:user) { create :user }

  describe '#user' do
    it 'returns the user' do
      subject.whodunnit = user.id
      expect(subject.user).to eql(user)
    end
  end
end
