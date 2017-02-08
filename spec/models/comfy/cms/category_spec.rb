RSpec.describe Comfy::Cms::Category do
  context 'navigation categories' do
    subject { described_class }

    let!(:navigation_category) { create(:category, navigation: true, label: 'Navigation', ordinal: 1) }
    let!(:non_navigation_category) { create(:category, navigation: false, label: 'Non Navigation') }
    let!(:navigation_category_position_2) do
      create(:category, navigation: true, label: 'Navigation Position 2', ordinal: 2)
    end

    it 'partitions the two types of categories' do
      left, right = subject.navigation_categories
      expect(left.first.label).to eq('Navigation')
      expect(right.first.label).to eq('Non Navigation')
    end

    it 'orders the partions in the correct ordinal' do
      left, _ = subject.navigation_categories
      expect(left).to eq([navigation_category, navigation_category_position_2])
    end
  end

  context 'relations' do
    let(:category)            { create(:category, label: 'category') }
    let!(:category_child)     { create(:category, parent_id: category.id, label: 'category_child', ordinal: 1) }
    let!(:category_child_2)   { create(:category, parent_id: category.id, label: 'category_child_2', ordinal: 2) }
    let(:category_grandchild) { create(:category, parent_id: category_child.id, label: 'category_grandchild') }

    it 'has many promo categories' do
      expect(subject).to have_many(:category_promos)
    end

    it 'returns the parent of the category' do
      expect(category_child.parent).to eq(category)
    end

    it 'returns all the parents of the category' do
      expect(category_grandchild.parents.map(&:label)).to eq(%w(category category_child))
    end

    it 'returns the direct child categories' do
      expect(category.child_categories.map(&:label)).to eq(%w(category_child category_child_2))
    end

    it { expect(described_class.new).to belong_to(:small_image) }
    it { expect(described_class.new).to belong_to(:large_image) }
  end

  describe '#clump_id' do
    let(:subject) { create(:category) }

    context 'when there is a clumping' do
      let!(:clumping) { create(:clumping, category: subject) }

      it 'returns the clump id from the clumping' do
        expect(subject.clump_id).to eq(clumping.clump_id)
      end
    end

    context 'when there is no clumping' do
      it 'returns nil' do
        expect(subject.clump_id).to be_nil
      end
    end
  end

  describe '#clump_id=' do
    let(:subject) { create(:category) }
    let(:clump) { create(:clump) }

    context 'assigning a new clump' do

      it 'associates the clump (through a clumping)' do
        subject.clump_id = clump.id
        expect(subject.reload.clump).to eq(clump)
      end
    end

    context 'unassigning a clump' do
      before { create(:clumping, clump: clump, category: subject) }

      it 'removes the clump (and clumping)' do
        subject.clump_id = nil
        expect(subject.clump).to be_nil
      end
    end
  end
end
