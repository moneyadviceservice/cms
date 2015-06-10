RSpec.describe CategoriesController, type: :controller do
  let(:site) { create(:site) }
  let(:current_user) { create(:user) }
  let(:category) { create(:category) }
  let(:sub_category_1) { create(:category, ordinal: 1, label: 'Sub Category 1', parent_id: category.id) }
  let(:sub_category_2) { create(:category, ordinal: 2, label: 'Sub Category 2', parent_id: category.id) }
  let(:params) do
    {
      'site_id' => "#{site.id}",
      'id' => "#{category.id}",
      'list_order_sub_categories' => "#{sub_category_2.id}, #{sub_category_1.id}",
      'comfy_cms_category' => {
        'title_en' => 'Debt and borrowing',
        'third_level_navigation' => '1'
      }
    }
  end

  before do
    sign_in current_user
  end

  describe '#update' do
    before do
      patch :update, params
    end

    it 'updates the order of the sub categories' do
      expect(category.reload.child_categories.map(&:label)).to eq(['Sub Category 2', 'Sub Category 1'])
    end

    it 'updates third_level_navigation' do
      expect(category.reload.third_level_navigation).to eq(true)
    end
  end
end
