RSpec.describe MainMenuHelper do
  let(:site) { Comfy::Cms::Site.new(id: 1) }
  let(:current_user) { double('User', admin?: admin) }

  subject { helper.menu_links(site).count }

  before do
    allow(helper).to receive(:current_user) { current_user }
  end

  context 'admin user' do
    let(:admin) { true }

    it 'returns with admin links' do
      expect(subject).to eq(3)
    end
  end

  context 'non admin user' do
    let(:admin) { false }

    it 'returns only non admin links' do
      expect(subject).to eq(2)
    end
  end
end
