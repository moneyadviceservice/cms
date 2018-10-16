def latest_revision(page)
  page.reload.revisions.order('id').last
end

def latest_revision_attributes(page)
  latest_revision(page).data[:blocks_attributes]
end

RSpec.describe AlternatePageBlocksRemover do
  let(:site) { create(:site) }
  let(:original_content) { 'original content' }
  let(:original_blocks_attributes) { [{ identifier: 'content', content: original_content }] }
  let(:scheduled_on) { nil }
  let(:published_revision) { nil }
  let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }
  let!(:block) { create(:block, blockable: page, content: original_content) }

  before do
    if published_revision.present?
      page.update_attribute(:active_revision, published_revision)
    end

    # Reload the page to make it see it's block
    page.reload
  end

  describe '#remove!' do
    let(:remover) { create(:user) }

    context 'when the page state is unsaved' do
      let(:state) { 'unsaved' }

      it 'raises an exception' do
        expect {
          described_class.new(page, remover: remover).remove!
        }.to raise_exception(AlternatePageBlocksRemover::Error)
      end
    end

    context 'when the page state is draft' do
      let(:state) { 'draft' }

      it 'raises an exception' do
        expect {
          described_class.new(page, remover: remover).remove!
        }.to raise_exception(AlternatePageBlocksRemover::Error)
      end
    end

    context 'when the page state is published' do
      let(:state) { 'published' }

      it 'raises an exception' do
        expect {
          described_class.new(page, remover: remover).remove!
        }.to raise_exception(AlternatePageBlocksRemover::Error)
      end
    end

    context 'when the page state is published_being_edited' do
      let(:state) { 'published_being_edited' }
      let(:published_revision) do
        create(:revision,
               record: page,
               data: {
                 blocks_attributes: [
                   {
                     identifier: 'content',
                     content: 'some content',
                     processed_content: "<p>some content</p>\n"
                   }
                 ]
               })
      end

      before do
        described_class.new(page, remover: remover).remove!
        page.reload
        block.reload
      end

      it 'changes the state to "published"' do
        expect(page).to be_published
      end

      it 'populates the block with the contents of the active revision' do
        expect(page.blocks_attributes).to eq published_revision.data[:blocks_attributes]
      end

      it 'creates a new revision with the old blocks attributes' do
        expect(latest_revision_attributes(page)).to eq original_blocks_attributes
      end

      it 'unsets the active revision' do
        expect(page.active_revision).to be_nil
      end
    end

    context 'and the state is scheduled' do
      let(:state) { 'scheduled' }

      it 'raises an exception' do
        expect {
          described_class.new(page, remover: remover).remove!
        }.to raise_exception(AlternatePageBlocksRemover::Error)
      end
    end

    context 'when the page state is unpublished' do
      let(:state) { 'unpublished' }

      it 'raises an exception' do
        expect {
          described_class.new(page, remover: remover).remove!
        }.to raise_exception(AlternatePageBlocksRemover::Error)
      end
    end
  end
end
