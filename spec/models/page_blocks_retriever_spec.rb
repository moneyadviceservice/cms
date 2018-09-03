RSpec.describe PageBlocksRetriever do
  describe '#live?' do
    let(:site) { create(:site) }
    let(:scheduled_on) { nil }
    let(:published_revision) { nil }
    let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }

    before do
      page.update_attribute(:active_revision, published_revision) if published_revision.present?

      # Reload the page to make it see it's block
      page.reload
    end

    subject { described_class.new(page) }

    context 'when a page is in a unsaved state' do
      let(:state) { 'unsaved' }

      it { should_not be_live }
    end

    context 'when a page is in a draft state' do
      let(:state) { 'draft' }

      it { should_not be_live }
    end

    context 'when a page is in a published state' do
      let(:state) { 'published' }

      it { should be_live }
    end

    context 'when a page is in a published_being_edited state' do
      let(:state) { 'published_being_edited' }

      it { should be_live }
    end

    context 'when a page is in a scheduled state' do
      let(:state) { 'scheduled' }

      context 'and scheduled_on is in the past' do
        let(:scheduled_on) { 1.minute.ago }

        it { should be_live }
      end

      context 'and scheduled_on is in the future' do
        let(:scheduled_on) { 1.minute.from_now }

        it { should_not be_live }

        context 'but there is an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it { should be_live }
        end
      end
    end

    context 'when a page is in a unpublished state' do
      let(:state) { 'unpublished' }

      it { should_not be_live }
    end
  end

  describe '#blocks_attributes' do
    let(:site) { create(:site) }
    let(:scheduled_on) { nil }
    let(:published_revision) { nil }
    let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }

    let(:blocks_attributes) { double('blocks attributes') }
    let(:active_revision_blocks_attributes) { double('active revision blocks attributes') }

    let(:retriever) { described_class.new(page) }

    before do
      allow(retriever).to receive(:return_page_blocks_attributes) { blocks_attributes }
      allow(retriever).to receive(:return_active_revision_blocks_attributes) { active_revision_blocks_attributes }

      page.update_attribute(:active_revision, published_revision) if published_revision.present?
    end

    subject { retriever.blocks_attributes }

    context 'when a page is in a unsaved state' do
      let(:state) { 'unsaved' }

      it { should eq blocks_attributes }
    end

    context 'when a page is in a draft state' do
      let(:state) { 'draft' }

      it { should eq blocks_attributes }
    end

    context 'when a page is in a published state' do
      let(:state) { 'published' }

      it { should eq blocks_attributes }
    end

    context 'when a page is in a published_being_edited state' do
      let(:state) { 'published_being_edited' }

      it { should eq active_revision_blocks_attributes }
    end

    context 'when a page is in a scheduled state' do
      let(:state) { 'scheduled' }

      context 'and scheduled_on is in the past' do
        let(:scheduled_on) { 1.minute.ago }

        it { should eq blocks_attributes }
      end

      context 'and scheduled_on is in the future' do
        let(:scheduled_on) { 1.minute.from_now }

        it { should eq blocks_attributes }

        context 'but there is an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it { should eq active_revision_blocks_attributes }
        end
      end
    end

    context 'when a page is in an unpublished state' do
      let(:state) { 'unpublished' }

      it { should eq blocks_attributes }
    end
  end
end
