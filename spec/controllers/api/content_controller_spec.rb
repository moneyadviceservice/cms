RSpec.describe API::ContentController, type: :request do
  let!(:site) { create(:site, path: 'en', locale: 'en') }
  let(:response_body) { JSON.load(response.body).symbolize_keys }

  before do
    allow_any_instance_of(PageSerializer).to receive(:related_content).and_return({})
  end

  describe 'GET /:locale/articles/:slug' do
    let(:state) { 'published' }
    let(:article_layout) { create(:layout, :article, site: site) }
    let!(:page) do
      create(:page, label: 'Borrow', slug: 'borrow', site: site, state: state, layout: article_layout)
    end

    before do
      get article_url
    end

    context 'when existing page' do
      let(:article_url) { '/en/articles/borrow' }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns successful response' do
        expect(response.status).to be 200
      end
    end

    context 'when draft page' do
      let(:state) { 'draft' }
      let(:article_url) { '/en/articles/borrow' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Page not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end

    context 'when inexistent site' do
      let(:article_url) { '/br/articles/borrow' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Site not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end

    context 'when inexistent page' do
      let(:article_url) { '/en/articles/inexistent-slug' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Page not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end
  end

  describe 'GET /:locale/corporate/:slug' do
    let(:corporate) { create(:layout, :corporate, site: site) }
    let!(:corporate_page) { create(:page, layout: corporate, site: site, slug: 'debt') }
    let!(:article_page) { create(:page, site: site, slug: 'borrow') }

    before do
      get page_url
    end

    context 'when "corporate" page' do
      let(:page_url) { '/en/corporate/debt' }

      it 'renders corporate page' do
        expect(response_body).to include(slug: 'debt')
      end

      it 'responds successfully' do
        expect(response.status).to be 200
      end
    end

    context 'when "article" page' do
      let(:page_url) { '/en/corporate/borrow' }

      it 'responds page not found' do
        expect(response_body).to eq(message: 'Page not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end
  end

  describe 'GET /:locale/action_plans/:slug' do
  end

  describe 'GET /preview/:locale/:slug' do
    let!(:page) { create(:page, label: 'Borrow', slug: 'borrow', site: site) }

    before do
      get preview_url
    end

    context 'when existent page' do
      let(:preview_url) { '/preview/en/borrow' }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns successful response' do
        expect(response.status).to be 200
      end
    end

    context 'when inexistent page' do
      let(:preview_url) { '/preview/en/inexistent-article' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Page not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end
  end
end
