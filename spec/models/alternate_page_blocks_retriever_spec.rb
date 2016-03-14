RSpec.describe AlternatePageBlocksRetriever do
  describe '#blocks_attributes' do
    let(:site) { create(:site) }
    let(:scheduled_on) { nil }
    let(:published_revision) { nil }
    let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }

    let(:blocks_attributes) { double('blocks attributes') }

    before do
      allow(page).to receive(:blocks_attributes) { blocks_attributes }

      if published_revision.present?
        # Using update_column here as some sort of callback tries to do
        # something with the page's block_content (which is a now double).
        page.update_column(:active_revision_id, published_revision.id)
      end
    end

    subject { described_class.new(page).blocks_attributes }

    context 'when a page is in a unsaved state' do
      let(:state) { 'unsaved' }

      it { should be_nil }
    end

    context 'when a page is in a draft state' do
      let(:state) { 'draft' }

      it { should be_nil }
    end

    context 'when a page is in a published state' do
      let(:state) { 'published' }

      it { should be_nil }
    end

    context 'when a page is in a published_being_edited state' do
      let(:state) { 'published_being_edited' }

      it { should eq blocks_attributes }
    end

    context 'when a page is in a scheduled state' do
      let(:state) { 'scheduled' }

      context 'and scheduled_on is in the past' do
        let(:scheduled_on) { 1.minute.ago }

        it { should be_nil }
      end

      context 'and scheduled_on is in the future' do
        let(:scheduled_on) { 1.minute.from_now }

        it { should be_nil }

        context 'but there is an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it { should eq blocks_attributes }
        end
      end
    end

    context 'when a page is in an unpublished state' do
      let(:state) { 'unpublished' }

      it { should be_nil }
    end
  end
end
