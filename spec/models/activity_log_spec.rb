require 'spec_helper'

RSpec.describe ActivityLog do
  describe '.fetch' do
    subject(:fetch) { ActivityLog.fetch(from: page) }
    let(:page) { double(revisions: revisions) }
    let(:created_at) { Time.now }
    let(:revision) { fetch.first }

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

      it 'assigns the activity log attributes as event type' do
        expect(fetch).to eq([
          ActivityLog.new(
            id: 1,
            author: 'user',
            type:   'event',
            text:   'draft',
            created_at: created_at
          )
        ])
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

      it 'assigns the activity log attributes as note type' do
        expect(fetch).to eq([
          ActivityLog.new(
            id: 1,
            author: 'user',
            type:   'note',
            text:   'note text',
            created_at: created_at
          )
        ])
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
end
