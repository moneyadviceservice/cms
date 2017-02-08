RSpec.describe ClumpsController, type: :controller do
  let(:site) { create(:site) }
  let(:current_user) { create(:user) }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:clump) { create(:clump, categories: [category_1, category_2]) }

  before do
    sign_in current_user
  end

  describe '#create' do
    let(:params) do
      {
        site_id: site,
        id: clump,
        clump: {
          name_en: Faker::Lorem.sentence,
          name_cy: Faker::Lorem.sentence,
          description_en: Faker::Lorem.paragraph,
          description_cy: Faker::Lorem.paragraph
        },
        category_order: "#{category_1.id}, #{category_2.id}"
      }
    end

    context 'when the params are invalid' do
      before { params[:clump][:name_en] = '' }

      it 'does not create the new record' do
        expect { post :create, params }.not_to change { Clump.count }
      end

      it 'renders the new template' do
        post :create, params
        expect(response).to render_template(:new)
      end
    end

    context 'when the params are valid' do
      it 'creates the new record' do
        expect { post :create, params }.to change { Clump.count }.by(1)
      end

      it 'redirects to the show page' do
        post :create, params
        expect(response).to redirect_to(action: :show, id: assigns(:clump).id)
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        site_id: site,
        id: clump,
        clump: {
          name_en: clump.name_en,
          name_cy: clump.name_cy,
          description_en: clump.description_en,
          description_cy: clump.description_cy
        },
        category_order: "#{category_1.id}, #{category_2.id}"
      }
    end

    context 'when the params are invalid' do
      before { params[:clump][:name_en] = '' }

      it 'does not save the change' do
        patch :update, params
        expect(clump.reload.name_en).to eq clump.name_en
      end

      it 'renders the new template' do
        patch :update, params
        expect(response).to render_template(:show)
      end
    end

    context 'when the params are valid' do
      let(:new_name_en) { Faker::Lorem.sentence }
      before { params[:clump][:name_en] = new_name_en }

      it 'saves the changes' do
        patch :update, params
        expect(clump.reload.name_en).to eq new_name_en
      end

      it 'redirects to the show page' do
        patch :update, params
        expect(response).to redirect_to(action: :show)
      end
    end

    context 'reordering the categories' do
      before { params[:category_order] = "#{category_2.id}, #{category_1.id}" }

      it 'updates the order of the categories' do
        patch :update, params
        expect(clump.reload.categories).to eq([category_2, category_1])
      end
    end
  end

  describe '#reorder' do
    let(:second_clump) { create(:clump) }

    it 'updates the order of the clumps' do
      patch :reorder, site_id: site, order: "#{second_clump.id}, #{clump.id}"
      expect(Clump.order(:ordinal)).to eq([second_clump, clump])
    end
  end
end
