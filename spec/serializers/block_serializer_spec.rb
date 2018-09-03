describe BlockSerializer do
  context 'when raw_ is the identifier' do
    let(:block_content) { 'raw content' }
    let(:page) { create(:page) }
    let(:block) do
      create(:block, identifier: 'raw_content',
                     blockable: page,
                     content: block_content)
    end

    subject { JSON.parse(described_class.new(block).to_json)['content'] }

    before { page.reload }

    it 'returns the raw content' do
      expect(subject).to eq(block_content)
    end
  end

  context 'when a collection is the identifier' do
    let(:page) { create(:page, state: 'published') }

    let!(:topics_saving) do
      create(:block, identifier: 'topics', content: 'Saving', blockable: page)
    end
    let!(:topics_pension) do
      create(:block, identifier: 'topics', content: 'Pension', blockable: page)
    end

    before { page.reload }

    context 'when requesting first element' do
      subject(:content) do
        described_class.new(topics_saving).content
      end

      it 'returns first element from the collection' do
        expect(content).to eq("<p>Saving</p>\n")
      end
    end

    context 'when requesting second element' do
      subject(:content) do
        described_class.new(topics_pension).content
      end

      it 'returns second element from the collection' do
        expect(content).to eq("<p>Pension</p>\n")
      end
    end
  end

  context 'when "content" is the identifier' do
    let(:scheduled_on) { nil }
    let(:published_revision) { nil }
    let(:block_content) { 'block content' }
    let(:block_content_wrapped_in_markup) { "<p>#{block_content}</p>\n" }
    let(:active_revision_content) { 'active revision content' }
    let(:active_revision_content_wrapped_in_markup) { "<p>#{active_revision_content}</p>\n" }
    let(:page) { create(:page, state: state, scheduled_on: scheduled_on) }
    let(:block) { create(:block, identifier: 'content', blockable: page, content: block_content) }

    before do
      page.update_attribute(:active_revision, published_revision) if published_revision.present?

      # Reload the page to make it see it's block
      page.reload
    end

    context 'without a scope provided' do
      subject { JSON.parse(described_class.new(block).to_json)['content'] }

      context 'with a page state of unsaved' do
        let(:state) { 'unsaved' }

        it { should be_nil }
      end

      context 'with a page state of draft' do
        let(:state) { 'draft' }

        it { should be_nil }
      end

      context 'with a page state of published' do
        let(:state) { 'published' }

        it { should eq block_content_wrapped_in_markup }
      end

      context 'with a page state of published_being_edited' do
        let(:state) { 'published_being_edited' }
        let(:published_revision) { create(:revision, content: active_revision_content, record: page) }

        it { should eq active_revision_content_wrapped_in_markup }
      end

      context 'with a page state of scheduled' do
        let(:state) { 'scheduled' }

        context 'and no active revision' do
          context 'with a scheduled_on timestamp in the past' do
            let(:scheduled_on) { 1.minute.ago }

            it { should eq block_content_wrapped_in_markup }
          end

          context 'with a scheduled_on timestamp in the future' do
            let(:scheduled_on) { 1.minute.from_now }

            it { should be_nil }
          end
        end

        context 'and an active revision' do
          let(:published_revision) { create(:revision, content: active_revision_content, record: page) }

          context 'with a scheduled_on timestamp in the past' do
            let(:scheduled_on) { 1.minute.ago }

            it { should eq block_content_wrapped_in_markup }
          end

          context 'with a scheduled_on timestamp in the future' do
            let(:scheduled_on) { 1.minute.from_now }

            it { should eq active_revision_content_wrapped_in_markup }
          end
        end
      end
    end

    context 'and the scope is "preview"' do
      subject { JSON.parse(described_class.new(block, scope: 'preview').to_json)['content'] }

      context 'with a page state of unsaved' do
        let(:state) { 'unsaved' }

        it { should eq block_content_wrapped_in_markup }
      end

      context 'with a page state of draft' do
        let(:state) { 'draft' }

        it { should eq block_content_wrapped_in_markup }
      end

      context 'with a page state of published' do
        let(:state) { 'published' }

        it { should eq block_content_wrapped_in_markup }
      end

      context 'with a page state of published_being_edited' do
        let(:state) { 'published_being_edited' }
        let(:published_revision) { create(:revision, content: active_revision_content, record: page) }

        it { should eq block_content_wrapped_in_markup }
      end

      context 'with a page state of scheduled' do
        let(:state) { 'scheduled' }

        context 'and no active revision' do
          context 'with a scheduled_on timestamp in the past' do
            let(:scheduled_on) { 1.minute.ago }

            it { should eq block_content_wrapped_in_markup }
          end

          context 'with a scheduled_on timestamp in the future' do
            let(:scheduled_on) { 1.minute.from_now }

            it { should eq block_content_wrapped_in_markup }
          end
        end

        context 'and an active revision' do
          let(:published_revision) { create(:revision, content: active_revision_content, record: page) }

          context 'with a scheduled_on timestamp in the past' do
            let(:scheduled_on) { 1.minute.ago }

            it { should eq block_content_wrapped_in_markup }
          end

          context 'with a scheduled_on timestamp in the future' do
            let(:scheduled_on) { 1.minute.from_now }

            it { should eq block_content_wrapped_in_markup }
          end
        end
      end
    end
  end
end
