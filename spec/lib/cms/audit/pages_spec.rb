describe Cms::Audit::Pages do
  let!(:role) { :user }
  let!(:current_user) { create(:user, role: Comfy::Cms::User.roles[role]) }
  let!(:state) { 'published' }
  let!(:site) { create(:site) }
  let!(:layout) { create(:layout) }
  let!(:page_with_tag) { create(:page_with_tag, site: site, state: state) }
  let!(:page_with_meta) { create(:article_with_metadata, site: site, state: state) }
  let!(:revision) do
   create(
     :revision_with_event,
     record: page_with_tag,
     user_id: current_user.id,
     user_name: current_user.name
  )
  end
  let!(:revision_2) do
   create(
     :revision_with_event,
     record: page_with_meta,
     user_id: current_user.id,
     user_name: current_user.name
  )
  end
  let!(:category) { create(:category, site: site) }
  let!(:categorization) do
    create(
      :categorization,
      categorized_id: page_with_tag.id,
      category: category,
      categorized_type: 'Comfy::Cms::Page'
    )
  end

  before do
    Timecop.freeze(Time.local(1990))
  end

  describe 'self.generate' do
    subject { described_class.generate_report(file: temp_file) }

    let(:temp_file) { Tempfile.new('temp_file.csv')}

    it 'generates a csv file and returns the count' do
      expect(subject).to eq 2
    end

    context 'csv file content' do
      before do
        subject
        @parsed_csv = CSV.read(temp_file)
      end

      after(:all) do
        Timecop.return
      end

      let(:expected_page_1) do
        [
          'Default Page',
          '/',
          'article',
          "[\"#{category.label}\"]",
          '["tag"]',
          nil,
          nil,
          nil,
          'false',
          'false',
          'true',
          '01/01/1990, 00:00',
          current_user.name,
          state
        ]
      end

      let(:expected_page_2) do
        [
          'Video Page Added',
          '/video-page-added',
          'video',
          '[]',
          '[]',
          'Just a meta description',
          'Meta title',
          'Csv, test',
          'false',
          'false',
          'true',
          '01/01/1990, 00:00',
          current_user.name,
          state
        ]
      end

      it 'creates a file with correct headers' do
        expect(@parsed_csv.first).to eq Cms::Audit::Pages::HEADERS
      end

      it 'populates the fields from the queried pages' do
        expect(@parsed_csv.second).to eq expected_page_1
      end

      it 'populates all fields if present' do
        expect(@parsed_csv.last).to eq expected_page_2
      end
    end
  end
end
