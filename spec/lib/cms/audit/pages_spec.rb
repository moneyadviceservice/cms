describe Cms::Audit::Pages do
  let(:role) { :user }
  let(:current_user) { create(:user, role: Comfy::Cms::User.roles[role]) }
  let(:state) { 'published' }
  let(:en_site) { create(:site) }
  let(:cy_site) { create(:site, label: 'cy') }
  let(:page_with_tags) { create(:page_with_multiple_tags, site: en_site, state: state) }
  let(:page_with_meta) { create(:article_with_metadata, site: cy_site, state: state) }
  let(:category) { create(:category, site: en_site) }

  before do
    Timecop.freeze(Time.zone.local(1990))
    create(
      :revision_with_event,
      record: page_with_tags,
      user_id: current_user.id,
      user_name: current_user.name
    )
    create(
      :revision_with_event,
      record: page_with_meta,
      user_id: current_user.id,
      user_name: current_user.name
    )
    create(
      :categorization,
      categorized_id: page_with_tags.id,
      category: category,
      categorized_type: 'Comfy::Cms::Page'
    )
  end

  describe 'self.generate' do
    subject { described_class.generate_report(file: temp_file) }

    let(:temp_file) { Tempfile.new('temp_file.csv') }

    it 'generates a csv file and returns the count of pages added' do
      expect(subject).to eq 2
    end

    describe 'csv file content' do
      subject(:parse_csv) do
        described_class.generate_report(file: temp_file)
        @parsed_csv = CSV.read(temp_file)
      end

      after(:all) { Timecop.return }

      let(:expected_page_1) do
        [
          'A page with two tags',
          '/',
          'article',
          category.label,
          'tag-2,tag-3',
          nil,
          nil,
          nil,
          'false',
          'false',
          'true',
          '01/01/1990, 00:00',
          current_user.name,
          state,
          'en'
        ]
      end

      let(:expected_page_2) do
        [
          'Video Page Added',
          '/video-page-added',
          'video',
          '',
          '',
          'Just a meta description',
          'Meta title',
          'Csv, test',
          'false',
          'false',
          'true',
          '01/01/1990, 00:00',
          current_user.name,
          state,
          'cy'
        ]
      end

      it 'used UTF-8 encoding' do
        expect(described_class::ENCODING).to eq 'UTF-8'
      end

      it 'creates a file with correct headers' do
        expect(parse_csv.first).to eq Cms::Audit::Pages::HEADERS
      end

      it 'populates the fields from the queried pages' do
        expect(parse_csv.second).to eq expected_page_1
      end

      it 'populates all fields if present' do
        expect(parse_csv.last).to eq expected_page_2
      end
    end
  end
end
