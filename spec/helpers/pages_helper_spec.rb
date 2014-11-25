describe PagesHelper do
  class Tester
    include PagesHelper
  end

  context 'new record' do
    let(:new_record) { true }
    let(:expected) { { dough_component: 'MirrorInputValue Slugifier' } }

    it 'returns a dough component hash' do
      expect(Tester.new.dough_component(true, %w(MirrorInputValue Slugifier))).to eq(expected)
    end
  end

  context 'existing record' do
    let(:new_record) { false }
    let(:expected) { {} }

    it 'returns an empty hash' do
      expect(Tester.new.dough_component(new_record)).to eq(expected)
    end
  end
end
