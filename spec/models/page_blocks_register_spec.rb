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
  let(:state) { 'unsaved' }
  let(:author) { create(:user) }

  subject(:page_block_register) do
    described_class.new(
      page,
      author: author,
      new_blocks_attributes: new_blocks_attributes
    )
  end

  describe '#save!' do
    let!(:block) { create(:block, blockable: page, content: original_content) }
    let(:page) { create(:page, site: site, state: state, scheduled_on: scheduled_on) }
    let(:author) { create(:user) }
    let(:new_content) { 'new content' }
    let(:new_blocks_attributes) { [{ identifier: 'content', content: new_content }] }

    before do
      if published_revision.present?
        page.update_attribute(:active_revision, published_revision)
      end

      # Reload the page to make it see it's block
      page.reload

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

  describe '#create_initial_blocks!' do
    let(:page) { build(:page) }

    before do
      page_block_register.create_initial_blocks!
      page.reload
    end

    context 'when content blocks' do
      context 'when block has content' do
        let(:new_blocks_attributes) do
          [
            { :identifier => 'content', :content => 'block content' }
          ]
        end

        it 'saved page to have a content block' do
          expect(page.blocks.size).to be(1)
          expect(page.blocks.first.identifier).to eq('content')
          expect(page.blocks.first.content).to eq('block content')
        end
      end

      context 'when block is empty' do
        let(:new_blocks_attributes) do
          [
            { :identifier => 'content', :content => '' }
          ]
        end

        it 'saved page to have a content block' do
          expect(page.blocks.size).to be(1)
          expect(page.blocks.first.identifier).to eq('content')
          expect(page.blocks.first.content).to eq('')
        end
      end
    end

    context 'when non content blocks' do
      context 'when blocks are empty' do
        let(:new_blocks_attributes) do
          [
            { :identifier => 'content', :content => 'block content' },
            { :identifier => 'topic', :content => '' },
            { :identifier => 'client_groups', :content => '' },
            { :identifier => 'data_types', :content => '' }
          ]
        end

        it 'saved page to have a content block' do
          expect(page.blocks.size).to be(1)
          expect(page.blocks.first.identifier).to eq('content')
          expect(page.blocks.first.content).to eq('block content')
        end
      end

      context 'when blocks has content' do
        let(:new_blocks_attributes) do
          [
            { :identifier => 'content', :content => 'block content' },
            { :identifier => 'topic', :content => 'Pension' }
          ]
        end

        it 'saved page to have a content block' do
          expect(page.blocks.size).to be(2)
          expect(page.blocks.first.identifier).to eq('content')
          expect(page.blocks.first.content).to eq('block content')
          expect(page.blocks.last.identifier).to eq('topic')
          expect(page.blocks.last.content).to eq('Pension')
        end
      end
    end
  end
end
