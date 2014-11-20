require 'spec_helper'

RSpec.describe RevisionData do
  describe '.load' do
    let(:revision) { double }
    let(:loader) { double }

    it 'parses the revision and transform to a hash' do
      allow(::RevisionData::Loader).to receive(:new).with(revision).and_return(loader)
      expect(loader).to receive(:to_hash).and_return(id: 42)

      expect(RevisionData.load(revision)).to eq(id: 42)
    end
  end

  describe '.dump' do
    let(:current_user) { double(id: 42, name: 'Luke') }

    context 'when note' do
      let(:revision_data) do
        { current_user: current_user, note: 'A note' }
      end

      it 'returns the revision data with note text' do
        expect(RevisionData.dump(revision_data)).to eq(
          author: {
            id:   42,
            name: 'Luke'
          },
          note: 'A note'
        )
      end
    end

    context 'when event' do
    end
  end

  describe ::RevisionData::Loader do
    subject(:loader) { described_class.new(double(data: revision_data)) }

    describe '#author' do
      context 'when revision have author' do
        let(:revision_data) do
          {
            author: {
              name: 'Luke'
            }
          }
        end

        it 'returns author name' do
          expect(loader.author).to eq('Luke')
        end
      end

      context 'when revision not have author' do
        let(:revision_data) { {} }

        it 'returns nil' do
          expect(loader.author).to be_nil
        end
      end
    end

    describe '#type' do
      context 'when event' do
        let(:revision_data) do
          {
            event: 'published'
          }
        end

        it 'returns "event"' do
          expect(loader.type).to eq('event')
        end
      end

      context 'when note' do
        let(:revision_data) do
          {
            note: 'Some note'
          }
        end

        it 'returns "note"' do
          expect(loader.type).to eq('note')
        end
      end

      context 'when blocks attributes' do
        let(:revision_data) do
          {
            blocks_attributes: [{
              identifier: 'content'
            }]
          }
        end

        it 'returns array' do
          expect(loader.type).to eq('blocks_attributes')
        end
      end
    end

    describe '#text' do
      context 'when event' do
        let(:revision_data) do
          {
            event: 'published'
          }
        end

        it 'returns the event status' do
          expect(loader.text).to eq('published')
        end
      end

      context 'when note' do
        let(:revision_data) do
          {
            note: 'Some note'
          }
        end

        it 'returns the content of the note' do
          expect(loader.text).to eq('Some note')
        end
      end

      context 'when blocks attributes' do
        let(:revision_data) do
          {
            blocks_attributes: [{
              identifier: 'content'
            }]
          }
        end

        it 'returns array' do
          expect(loader.text).to eq([{ identifier: 'content' }])
        end
      end
    end
  end
end
