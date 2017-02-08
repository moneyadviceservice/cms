describe Clump do
  describe 'validations' do
    # Test validation on a saved record, to avoid complication
    # arising from the default population of ordinal
    subject { create(:clump) }

    it { should validate_presence_of(:name_en) }
    it { should validate_presence_of(:name_cy) }
    it { should validate_presence_of(:description_en) }
    it { should validate_presence_of(:description_cy) }
    it { should validate_presence_of(:ordinal) }
  end

  describe 'default ordinal' do
    it 'is present on a new clump' do
      expect(create(:clump).ordinal).to be_present
    end

    it 'is numbered appropriately' do
      rand(1..5).times { create(:clump) }
      expect(create(:clump).ordinal).to eq(Clump.count - 1)
    end
  end
end
