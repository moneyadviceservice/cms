RSpec.describe CategoriesController, type: :controller do
  let(:site) { create(:site) }
  let(:current_user) { create(:user) }
  let(:category_promo) do
    CategoryPromo.new(promo_type: 'blog', title: 'title', description: 'description', locale: 'en')
  end
  let!(:category) do
    create(:category, category_promos: [category_promo], links: [Link.new(text: 'a', url: 'b', locale: 'en')])
  end
  let(:sub_category_1) { create(:category, ordinal: 1, label: 'Sub Category 1', parent_id: category.id) }
  let(:sub_category_2) { create(:category, ordinal: 2, label: 'Sub Category 2', parent_id: category.id) }
  let(:params) do
    {
      'site_id' => site.id.to_s,
      'id' => category.id.to_s,
      'list_order_sub_categories' => "#{sub_category_2.id}, #{sub_category_1.id}",
      'comfy_cms_category' => {
        'title_en' => 'Debt and borrowing',
        'third_level_navigation' => '1',
        'links_attributes' => {
          '0' => { 'id' => category.links.first.id.to_s, '_destroy' => '1' }
        },
        'category_promos_attributes' => {
          '0' => {
            promo_type: 'blog',
            title: 'Some promotion',
            description: 'some description',
            locale: 'en',
            id: category_promo.id,
            _destroy: true
          },
          '1' => { promo_type: '', title: '', description: '', locale: '' }
        }
      }
    }
  end

  before do
    sign_in current_user
  end

  describe '#update' do
    it 'updates the order of the sub categories' do
      patch :update, params
      expect(category.reload.child_categories.map(&:label)).to eq(['Sub Category 2', 'Sub Category 1'])
    end

    it 'updates third_level_navigation' do
      patch :update, params
      expect(category.reload.third_level_navigation).to eq(true)
    end

    it 'deletes specified links' do
      expect { patch :update, params }.to change(Link, :count).by(-1)
    end

    it 'updates category promos' do
      expect { patch :update, params }.to change(CategoryPromo, :count).by(-1)
    end
  end

  describe '#create' do
    let(:params) do
      {
        'comfy_cms_category' => {
          'site_id' => site.id.to_s,
          'label' => 'debt-and-borrowing',
          'title_en' => 'Debt and borrowing',
          'title_cy' => 'Welsh Debt and borrowing',
          'categorized_type' => 'Comfy::Cms::Page', # i have no idea what this is
          'third_level_navigation' => '1',
          'links_attributes' => {
            '0' => { 'text' => 'some link', 'url' => 'http://www.example.com', 'locale' => 'en' },
            '1' => { 'text' => 'test 2', 'url' => 'http://yahoo.com', 'locale' => 'en' },
            '3' => { 'text' => '', 'url' => '', 'locale' => '' }
          },
          'category_promos_attributes' => {
            '0' => { promo_type: 'blog', title: 'Some promotion', description: 'some description', locale: 'en' }
          }
        }
      }
    end

    it 'persists the category' do
      expect { post :create, params }.to change(Comfy::Cms::Category, :count).by(1)
    end

    it 'persists top links' do
      expect { post :create, params }.to change(Link, :count).by(2)
    end

    it 'creates category promos' do
      expect { post :create, params }.to change(CategoryPromo, :count).by(1)
    end
  end
end
