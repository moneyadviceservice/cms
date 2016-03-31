RSpec.describe PageMirrorPresenter do
  subject(:presenter) do
    described_class.new(object)
  end

  describe 'label' do
    subject(:label) { presenter.label }

    context 'when english label' do
      let(:object) { double(label: 'Before Borrow') }

      it 'returns english label' do
        expect(label).to eq('Before Borrow')
      end
    end

    context 'when english label is blank' do
      let(:object) { double(label: nil, page_label: 'Cy Foo Bar') }

      it 'returns english label' do
        expect(label).to eq('Cy Foo Bar')
      end
    end
  end
end
