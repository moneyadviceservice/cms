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

  describe '#disabled?' do
    context 'when page is published' do
      let(:object) { double(published?: true) }

      it 'returns false' do
        expect(presenter).to_not be_disabled
      end
    end

    context 'when page published being edited' do
      let(:object) { double(published?: false, published_being_edited?: true) }

      it 'returns false' do
        expect(presenter).to_not be_disabled
      end
    end

    context 'when page is not published or published being edited' do
      let(:object) { double(published?: false, published_being_edited?: false) }

      it 'returns true' do
        expect(presenter).to be_disabled
      end
    end
  end
end
