describe Clumping do
  let(:clump) { create(:clump) }

  describe 'validations' do
    # Test validation on a saved record, to avoid complication
    # arising from the default population of ordinal
    subject { create(:clumping, clump: clump) }

    it { should validate_presence_of(:clump) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:ordinal) }
  end

  describe 'default ordinal' do
    let(:clumping) { create(:clumping, clump: clump, category: create(:category)) }

    it 'is present on a new clump' do
      expect(clumping.ordinal).to be_present
    end

    it 'is numbered appropriately' do
      rand(1..5).times { create(:clumping, clump: clump, category: create(:category)) }
      expect(clumping.ordinal).to eq(clump.reload.clumpings.count - 1)
    end
  end
end
