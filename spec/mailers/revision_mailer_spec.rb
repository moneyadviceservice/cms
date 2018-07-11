require 'rails_helper'

RSpec.describe RevisionMailer, type: :mailer do
  let(:user) { FactoryBot.build(:user, name: 'Mr. Ed Itor') }
  let(:page) { FactoryBot.create(:page, label: 'How to save 50p a day.') }

  describe '#external_editor_change' do
    let(:email) { described_class.external_editor_change(user: user, page: page) }

    it 'sets the email "from"' do
      expect(email.from).to eq(['notmonitored@notify.moneyadviceservice.org.uk'])
    end

    it 'sets the email "subject"' do
      expect(email.subject).to eq('Content updated by External Editor')
    end

    it 'sets the email recipient' do
      expect(email.to.length).to eq(1)
      expect(email.to).to include('welsh.editors@moneyadviceservice.org.uk')
    end

    it "includes the editor's name in the body" do
      expect(email.body).to include('Mr. Ed Itor')
    end

    it 'includes the page title in the body' do
      expect(email.body).to include('How to save 50p a day.')
    end

    it 'includes a link to the page' do
      url = "http://mas.example.com/admin/sites/#{page.site_id}/pages/#{page.id}/edit"
      expect(email.body).to include(url)
    end
  end
end
