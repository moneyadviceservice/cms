describe Cms::Audit::Pages do
  let!(:role) { :user }
  let!(:current_user) { create(:user, role: Comfy::Cms::User.roles[role]) }
  let!(:state) { 'published' }
  let!(:site) { create(:site) }
  let!(:layout) { create(:layout) }
  let!(:page) { create(:english_article, site: site, state: state) }
  let!(:page_with_meta) { create(:article_with_metadata, site: site, state: state) }
  let!(:revision) do
   create(
     :revision_with_event,
     record: page,
     user_id: current_user.id,
     user_name: current_user.name
  )
  end

  # Need AuditComponent table lookup

  describe 'self.generate' do
    subject { described_class.generate_report }
    it 'generates a csv file and returns the count' do
      expect(subject).to eq 2
    end

    context 'csv file context' do
      let(:expected_page) do
        [
          'Default Page',
          '/',
          'article',
          '[]',
          '[]',
          nil,
          nil,
          nil,
          'false',
          'false',
          'true',
          '17/01/2019, 14:42',
          current_user.name,
          state
        ]
      end

      before do
        subject
        @parsed_csv = CSV.read(Rails.root.join('audit-test.csv').to_s)
      end

      it 'creates a file with correct headers' do
        expect(@parsed_csv.first).to eq Cms::Audit::Pages::HEADERS
      end

      it 'populates the fields from the queried pages' do
        expect(@parsed_csv.second).to eq expected_page
      end
    end
  end
end
