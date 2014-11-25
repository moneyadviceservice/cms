RSpec.describe PagePresenter do
  subject(:presenter) do
    described_class.new(object)
  end

  describe '#last_update' do
    let(:object) { double(updated_at: Time.new(2014, 8, 1, 14, 45)) }

    it 'returns the author and the created at formated' do
      expect(presenter.last_update).to eq("01/08/2014, 14:45")
    end
  end
end
