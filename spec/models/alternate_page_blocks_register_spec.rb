def latest_revision(page)
  page.reload.revisions.order('id').last
end

def latest_revision_attributes(page)
  latest_revision(page).data[:blocks_attributes]
end

RSpec.describe AlternatePageBlocksRegister do
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

  describe '#save!' do
    let(:author) { create(:user) }
    let(:new_content) { 'new content' }
    let(:new_blocks_attributes) do
      [
        {
          identifier: 'content',
          content: new_content,
          processed_content: "<p>new content</p>\n"
        }
      ]
    end

    context 'when the page state is unsaved' do
      let(:state) { 'unsaved' }

      it 'raises an exception' do
        expect {
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
        }.to raise_exception
      end
    end

    context 'when the page state is draft' do
      let(:state) { 'draft' }

      it 'raises an exception' do
        expect {
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
        }.to raise_exception
      end
    end

    context 'when the page state is published' do
      let(:state) { 'published' }

      it 'raises an exception' do
        expect {
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
        }.to raise_exception
      end
    end

    context 'when the page state is published_being_edited' do
      let(:state) { 'published_being_edited' }

      context 'and there has been no state change' do
        before do
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
          page.reload
          block.reload
        end

        it 'updates the blocks with the new attributes' do
          expect(page.blocks_attributes).to eq new_blocks_attributes
        end

        it 'creates a new revision with the old blocks attributes' do
          expect(latest_revision_attributes(page)).to eq original_blocks_attributes
        end

        it 'does not assign an active revision' do
          expect(page.active_revision).to be_nil
        end
      end

      context 'and the state has just changed from published' do
        let(:state) { 'published' }

        before do
          page.update_state(:create_new_draft)
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
          page.reload
          block.reload
        end

        it 'updates the blocks with the new attributes' do
          expect(page.blocks_attributes).to eq new_blocks_attributes
        end

        it 'creates a new revision with the old blocks attributes' do
          expect(latest_revision_attributes(page)).to eq original_blocks_attributes
        end

        it 'assigns the new revision to the active revision' do
          expect(page.reload.active_revision).to eq latest_revision(page)
        end
      end

      context 'and the state has just changed from scheduled' do
        let(:state) { 'scheduled' }
        let(:scheduled_on) { 1.minute.ago }

        before do
          page.update_state(:create_new_draft)
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
          page.reload
          block.reload
        end

        context 'with no active revision' do
          it 'updates the blocks with the new attributes' do
            expect(page.blocks_attributes).to eq new_blocks_attributes
          end

          it 'creates a new revision with the old blocks attributes' do
            expect(latest_revision_attributes(page)).to eq original_blocks_attributes
          end

          it 'assigns the new revision to the active revision' do
            expect(page.reload.active_revision).to eq latest_revision(page)
          end

          it 'clears the scheduled_on timestamp' do
            expect(page.scheduled_on).to be_nil
          end
        end

        context 'with an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it 'updates the blocks with the new attributes' do
            expect(page.blocks_attributes).to eq new_blocks_attributes
          end

          it 'creates a new revision with the old blocks attributes' do
            expect(latest_revision_attributes(page)).to eq original_blocks_attributes
          end

          it 'assigns the new revision to the active revision' do
            expect(page.reload.active_revision).to eq latest_revision(page)
          end

          it 'clears the scheduled_on timestamp' do
            expect(page.scheduled_on).to be_nil
          end
        end
      end
    end

    context 'when the page state is scheduled' do
      let(:state) { 'scheduled' }

      context 'and is live' do
        let(:scheduled_on) { 1.minute.ago }

        context 'with no active revision' do
          it 'raises an exception' do
            expect {
              described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
            }.to raise_exception
          end
        end

        context 'with an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it 'raises an exception' do
            expect {
              described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
            }.to raise_exception
          end
        end
      end

      context 'but is not live' do
        let(:scheduled_on) { 1.minute.from_now }

        context 'with no active revision' do
          it 'raises an exception' do
            expect {
              described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
            }.to raise_exception
          end
        end

        context 'with an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          before do
            described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
            page.reload
            block.reload
          end

          it 'updates the blocks with the new attributes' do
            expect(page.blocks_attributes).to eq new_blocks_attributes
          end

          it 'creates a new revision with the old blocks attributes' do
            expect(latest_revision_attributes(page)).to eq original_blocks_attributes
          end

          it 'changes the active revision' do
            expect(page.reload.active_revision).to eq published_revision
          end
        end
      end
    end

    context 'when the page state is unpublished' do
      let(:state) { 'unpublished' }

      it 'raises an exception' do
        expect {
          described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
        }.to raise_exception
      end
    end
  end
end
