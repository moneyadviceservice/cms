describe RedirectsController do
  describe 'auth' do
    context 'when not logged in' do
      it 'redirects user to login' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when non admin logged in' do
      let(:current_user) { create(:user) }

      before :each do
        create(:site)
        sign_in current_user
      end

      it 'redirects to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when admin logged in' do
      let(:current_user) { create(:admin_user) }

      before :each do
        create(:site)
        sign_in current_user
      end

      it 'lets the user in' do
        get :index
        expect(response).to be_success
      end
    end
  end
end

describe RedirectsController do
  let(:current_user) { create(:admin_user) }

  before do
    create(:site)
    sign_in current_user
  end

  describe '#new' do
    it 'works' do
      get :new
      expect(response).to be_success
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end

    it 'assigns a new redirect' do
      get :new
      expect(assigns(:redirect)).to be_a(Redirect)
    end
  end

  describe '#create' do
    it 'creates a new redirect' do
      expect do
        post :create, redirect: { source: '/en/foo', destination: '/en/bar', redirect_type: 'temporary' }
      end.to change(Redirect, :count).by(1)
    end

    it 'redirects to index' do
      post :create, redirect: { source: '/en/foo', destination: '/en/bar', redirect_type: 'temporary' }
      expect(response).to redirect_to(redirects_path)
    end

    it 'flashes success' do
      post :create, redirect: { source: '/en/foo', destination: '/en/bar', redirect_type: 'temporary' }
      expect(flash[:success]).to be_present
    end

    describe 'sad path' do
      it 'renders the form' do
        post :create, redirect: { source: '/en/foo', destination: '/en/foo', redirect_type: 'temporary' }
        expect(response).to render_template('new')
      end

      it 'flashes errors' do
        post :create, redirect: { source: '/en/foo', destination: '/en/foo', redirect_type: 'temporary' }
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe '#index' do
    it 'works' do
      get :index
      expect(response).to be_success
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#show' do
    let!(:redirect) { create(:redirect) }

    it 'works' do
      get :show, id: redirect.id
    end
  end

  describe '#update' do
    let!(:redirect) { create(:redirect) }

    it 'updates the record' do
      expect do
        put :update, id: redirect.id, redirect: { source: '/en/a' }
      end.to change { redirect.reload.source }.to('/en/a')
    end

    it 'redirects to index' do
      put :update, id: redirect.id, redirect: { source: '/en/a' }
      expect(response).to redirect_to(redirects_path)
    end

    context 'when invalid' do
      it 'renders show' do
        put :update, id: redirect.id, redirect: { source: '/en/bar' }
        expect(response).to render_template('redirects/show')
      end
    end
  end

  describe '#destroy' do
    let!(:redirect) { create(:redirect) }

    it 'flags redirect as inactive' do
      expect do
        delete :destroy, id: redirect.id
      end.to change { redirect.reload.active }.from(true).to(false)
    end

    it 'redirects back to index' do
      delete :destroy, id: redirect.id
      expect(response).to redirect_to(redirects_path)
    end
  end

  describe '#search' do
    before :each do
      create :redirect
    end

    it 'populates @search' do
      get :search, redirect_search: { query: 'foo' }
      expect(assigns[:redirects]).to be_present
    end

    it 'search results can be paginated' do
      get :search, redirect_search: { query: 'foo' }
      expect(assigns[:redirects].current_page).to be_present
    end
  end

  describe '#help' do
    it 'works' do
      get :help
      expect(response).to be_success
    end
  end
end
