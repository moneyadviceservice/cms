def latest_revision(page)
  page.revisions.order('id').last
end

def latest_revision_content(page)
  latest_revision(page).data[:blocks_attributes].find { |a| a[:identifier] == 'content' }[:content]
end

RSpec.describe PageBlocksRegister do
  let(:site) { create(:site) }
  let(:original_content) { 'original content' }
  let(:scheduled_on) { nil }
  let(:published_revision) { nil }
  let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }
  let!(:block) { create(:block, blockable: page, content: original_content) }
  let(:state) { 'unsaved' }
  let(:author) { create(:user) }

  subject(:page_block_register) { described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes) }

  before do
    if published_revision.present?
      page.update_attribute(:active_revision, published_revision)
    end

    # Reload the page to make it see it's block
    page.reload
  end

  describe '#new_blocks_attributes' do
    let(:state) { 'unsaved' }
    let(:author) { create(:user) }
    let(:page) { create :homepage }

    subject(:page_block_register) { described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes) }

    let!(:actual_blocks) do
      page_block_register.new_blocks_attributes
    end

    let!(:block) { create(:block,
                         blockable: page,
                         identifier: 'raw_tile_2_image',
                         content: 'http://e.co/original/UC.jpg' ) }
    let(:new_blocks_attributes) { page.blocks_attributes }

		it 'expects page to have image_srcset block' do
      expect(actual_blocks.map{ |b| b[:identifier] }).to include('raw_tile_1_srcset', 'raw_tile_2_image')
		end

    it 'expects image srcset to contain correct srcset info' do
      expect(actual_blocks.map{ |b| b[:content] }).to include('http://e.co/extra_small/UC.jpg 390w, http://e.co/small/UC.jpg 485w, http://e.co/medium/UC.jpg 900w, http://e.co/large/UC.jpg 1350w')
    end
  end

  describe '#save!' do
    let(:author) { create(:user) }
    let(:new_content) { 'new content' }
    let(:new_blocks_attributes) { [{ identifier: 'content', content: new_content }] }

    before do
      described_class.new(page, author: author, new_blocks_attributes: new_blocks_attributes).save!
      page.reload
      block.reload
    end

    context 'when the page state is unsaved' do
      let(:state) { 'unsaved' }

      it 'updates the blocks with the new blocks attributes' do
        expect(block.content).to eq new_content
      end

      it 'creates a new revision with the old blocks attributes' do
        expect(latest_revision_content(page)).to eq original_content
      end

      it 'does not assign an active revision' do
        expect(page.active_revision).to be_nil
      end
    end

    context 'when the page state is draft' do
      let(:state) { 'draft' }

      it 'updates the blocks with the new blocks attributes' do
        expect(block.content).to eq new_content
      end

      it 'creates a new revision with the old blocks attributes' do
        expect(latest_revision_content(page)).to eq original_content
      end

      it 'does not assign an active revision' do
        expect(page.active_revision).to be_nil
      end
    end

    context 'when the page state is published' do
      let(:state) { 'published' }

      it 'updates the blocks with the new blocks attributes' do
        expect(block.content).to eq new_content
      end

      it 'creates a new revision with the old blocks attributes' do
        expect(latest_revision_content(page)).to eq original_content
      end

      it 'does not assign an active revision' do
        expect(page.active_revision).to be_nil
      end

      context 'and there is an active revision' do
        let(:published_revision) { create(:revision, record: page) }

        it 'unsets the active revision' do
          expect(page.active_revision).to be_nil
        end
      end
    end

    context 'when the page state is published_being_edited' do
      let(:state) { 'published_being_edited' }

      it 'should not update the blocks content' do
        expect(block.content).to eq original_content
      end

      it 'creates a new revision with the new content' do
        expect(latest_revision_content(page)).to eq new_content
      end

      it 'assigns the new revision to the active revision' do
        expect(page.active_revision).to eq latest_revision(page)
      end
    end

    context 'when the page state is scheduled' do
      let(:state) { 'scheduled' }

      context 'and is live' do
        let(:scheduled_on) { 1.minute.ago }

        it 'updates the blocks with the new blocks attributes' do
          expect(block.content).to eq new_content
        end

        it 'creates a new revision with the old blocks attributes' do
          expect(latest_revision_content(page)).to eq original_content
        end

        it 'does not assign an active revision' do
          expect(page.active_revision).to be_nil
        end
      end

      context 'and is not live yet' do
        let(:scheduled_on) { 1.minute.from_now }

        context 'but there is an active revision' do
          let(:published_revision) { create(:revision, record: page) }

          it 'does not update the block content' do
            expect(block.content).to eq original_content
          end

          it 'creates a new revision with the new content' do
            expect(latest_revision_content(page)).to eq new_content
          end

          it 'assigns the new revision to the active revision' do
            expect(page.active_revision).to eq latest_revision(page)
          end
        end

        context 'and there is no active revision' do
          it 'updates the blocks with the new blocks attributes' do
            expect(block.content).to eq new_content
          end

          it 'creates a new revision with the old blocks attributes' do
            expect(latest_revision_content(page)).to eq original_content
          end

          it 'does not assign an active revision' do
            expect(page.active_revision).to be_nil
          end
        end
      end
    end

    context 'when the page state is unpublished' do
      let(:state) { 'unpublished' }

      it 'updates the blocks content' do
        expect(block.content).to eq new_content
      end

      it 'creates a new revision with the old blocks attributes' do
        expect(latest_revision_content(page)).to eq original_content
      end

      it 'does not assign an active revision' do
        expect(page.active_revision).to be_nil
      end
    end
  end

end
