RSpec.describe ActivityLog do
  describe '.fetch' do
    subject(:fetch) { ActivityLog.fetch(from: page) }
    let(:page) { double(revisions: revisions) }
    let(:created_at) { Time.now }
    let(:revision) { fetch.first }

    before do
      expect(revisions).to receive(:reorder).with(created_at: :asc).and_return(revisions)
    end

    context 'when revisions have author and event information' do
      let(:revisions) do
        [
          double(
            id: 1,
            data: {
              author: { name: 'user' },
              event:  'draft'
            },
            created_at: created_at
          )
        ]
      end

      it 'parses the revision' do
        expect(fetch).to contain_exactly(
          ActivityLog.new(
            id: 1,
            author: 'user',
            type: 'event',
            text: 'draft',
            created_at: created_at
          )
        )
      end
    end

    context 'when revisions have notes information' do
      let(:revisions) do
        [
          double(
            id: 1,
            data: {
              author: { name: 'user' },
              note:   'note text'
            },
            created_at: created_at
          )
        ]
      end

      it 'parses the revision' do
        expect(fetch).to contain_exactly(
          ActivityLog.new(
            id: 1,
            author: 'user',
            type: 'note',
            text: 'draft',
            created_at: created_at
          )
        )
      end
    end

    context 'when revisions does not have event history' do
      let(:revisions) do
        [
          double(
            id: 1,
            data: {
              blocks_attributes: { identifier: 'default_page_text' }
            },
            created_at: created_at
          )
        ]
      end

      it 'returns empty array' do
        expect(fetch).to eq([])
      end
    end
  end

  describe '.parse' do
    let(:revision) { double }

    it 'loads the revision data' do
      allow(RevisionData).to receive(:load).with(revision).and_return(id: 1)
      expect(ActivityLog.parse(revision)).to eq(ActivityLog.new(id: 1))
    end
  end

  describe '#blocks_attributes?' do
    let(:activity_log) { ActivityLog.new(type: activity_log_type)}

    context 'when blocks attributes' do
      let(:activity_log_type) { 'blocks_attributes' }

      it 'returns true' do
        expect(activity_log).to be_blocks_attributes
      end
    end

    context 'when note' do
      let(:activity_log_type) { 'note' }

      it 'returns false' do
        expect(activity_log).to_not be_blocks_attributes
      end
    end
  end
end
