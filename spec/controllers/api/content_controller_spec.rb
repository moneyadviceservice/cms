RSpec.describe API::ContentController, type: :request do
  let!(:site) { create(:site, path: 'en', locale: 'en') }
  let(:response_body) { JSON.load(response.body).symbolize_keys }

  describe 'GET /:locale/articles/:slug' do
    let!(:page) { create(:page, label: 'Borrow', slug: 'borrow', site: site) }

    before do
      allow_any_instance_of(PageSerializer).to receive(:related_content).and_return({})
      get article_url
    end

    context 'when existing article' do
      let(:article_url) { '/en/articles/borrow' }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns successful response' do
        expect(response.status).to be 200
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

    context 'when inexistent article' do
      let(:article_url) { '/en/articles/inexistent-slug' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Page not found')
      end

      it 'responds not found' do
        expect(response.status).to be 404
      end
    end
  end

  describe 'GET /preview/:locale/:slug' do
    let!(:page) { create(:page, label: 'Borrow', slug: 'borrow', site: site) }

    before do
      allow_any_instance_of(PageSerializer).to receive(:related_content).and_return({})
      get preview_url
    end

    context 'when existent article' do
      let(:preview_url) { '/preview/en/borrow' }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns successful response' do
        expect(response.status).to be 200
      end
    end

    context 'when inexistent article' do
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
