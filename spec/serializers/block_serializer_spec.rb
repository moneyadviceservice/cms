describe BlockSerializer do
  let(:object) { Comfy::Cms::Block.new(blockable: page, content: 'published content') }
  subject { JSON.parse(described_class.new(object).to_json)['content'] }

  context 'when page is published' do
    let(:page) { Comfy::Cms::Page.new(state: 'published') }

    it 'returns the blocks content' do
      expect(subject).to eq('published content')
    end
  end

  context 'when page is published being edited' do
    let(:blocks_attributes) { [{ identifier: 'content', content: 'Last published content' }] }
    let(:data) { { previous_event: 'published', blocks_attributes: blocks_attributes } }
    let(:revisions) { Comfy::Cms::Revision.new(data: data) }
    let(:page) { Comfy::Cms::Page.new(state: 'published_being_edited', revisions: [revisions]) }

    it 'returns the last published content' do
      expect(subject).to eq('Last published content')
    end
  end

  context 'when scheduled date is in the past' do
    let(:passed_date) { Time.current - 1.day }
    let(:page) { Comfy::Cms::Page.new(state: 'scheduled', scheduled_on: passed_date) }

    it 'returns the blocks content' do
      expect(subject).to eq('published content')
    end
  end

  context 'when scheduled date in the future' do
    let(:future_date) { Time.current + 1.day }
    let(:blocks_attributes) { [{ identifier: 'content', content: 'Last published content' }] }
    let(:data) { { previous_event: 'published', blocks_attributes: blocks_attributes } }
    let(:revisions) { Comfy::Cms::Revision.new(data: data) }
    let(:page) { Comfy::Cms::Page.new(state: 'scheduled', scheduled_on: future_date, revisions: [revisions]) }

    it 'returns the last published revision content' do
      expect(subject).to eq('Last published content')
    end
  end
end
