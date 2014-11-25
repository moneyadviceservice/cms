RSpec.describe ActivityLogPresenter do
  subject(:presenter) do
    described_class.new(object)
  end

  describe '#header' do
    let(:object) do
      ActivityLog.new(author: 'Luke', created_at: Time.new(2014, 8, 1, 14, 45))
    end

    it 'returns the author and the created at formated' do
      expect(presenter.header).to eq 'Luke, 01/08/2014, 14:45'
    end
  end

  describe '#description' do
    context 'when is an event' do
      let(:object) do
        ActivityLog.new(type: 'event', text: 'draft')
      end

      it 'returns the text description about the event status' do
        expect(presenter.description).to eq 'Status: draft'
      end
    end

    context 'when is a note' do
      let(:object) do
        ActivityLog.new(type: 'note', text: 'Not able to do the translation')
      end

      it 'returns the text from activity log' do
        expect(presenter.description).to eq 'Not able to do the translation'
      end
    end
  end

  describe '#data_attribute' do
    context 'when is an event' do
      let(:object) do
        ActivityLog.new(type: 'event', text: 'draft')
      end

      it 'returns nil' do
        expect(presenter.data_attribute).to be_nil
      end
    end

    context 'when is a note' do
      let(:object) do
        ActivityLog.new(type: 'note', text: 'Not able to do the translation')
      end

      it 'returns the data attribute to be used in element filter component' do
        expect(presenter.data_attribute).to eq(dough_element_filter_item: 'true')
      end
    end
  end
end