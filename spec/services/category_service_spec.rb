RSpec.describe CategoryService do
  let(:category_params) { { title_en: 'test' } }
  let(:sub_category_params) { {} }
  let(:category) { create(:category) }
  let(:category_1) { create(:category, ordinal: 1, parent_id: category.id) }
  let(:category_2) { create(:category, ordinal: 2, parent_id: category.id) }
  let(:category_3) { create(:category, ordinal: 3, parent_id: category.id) }

  subject { described_class.new(category, category_params, sub_category_params) }
  before { subject.update_category! }

  context 'categories' do
    it 'update the category attributes' do
      expect(category.title_en).to eq('test')
    end

    context 'sub categories' do
      let(:category_order) { "#{category_3.id}, #{category_2.id}, #{category_1.id}" }
      let(:sub_category_params) { { list_order_sub_categories: category_order } }

      it 'update the sub category order' do
        expect(category.child_categories).to eq([category_3, category_2, category_1])
      end
    end
  end

  context 'categorization ordinal of pages' do
    let(:categorization_1) { create(:categorization, category_id: category.id, categorized_id: 1) }
    let(:categorization_2) { create(:categorization, category_id: category.id, categorized_id: 2) }
    let(:categorization_order) { "#{categorization_2.categorized_id}, #{categorization_1.categorized_id}" }
    let(:sub_category_params) { { list_order_pages_en: categorization_order } }

    it 'update the categorization order' do
      expect(categorization_1.reload.ordinal).to eq(2)
    end
  end
end
