require 'spec_helper'

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
        expect(described_class).to receive(:parse).with(revisions.first)
        fetch
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
        expect(described_class).to receive(:parse).with(revisions.first)
        fetch
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
end
