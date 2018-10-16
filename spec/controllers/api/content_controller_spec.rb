RSpec.describe API::ContentController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end
  let!(:welsh) do
    create(:site, :welsh, is_mirrored: true, path: 'cy', locale: 'cy')
  end
  let(:response_body) { JSON.load(response.body).symbolize_keys }

  before do
    allow_any_instance_of(PageSerializer)
      .to receive(:related_content).and_return({})
  end

  describe 'GET /:locale/videos/published.json' do
    let!(:video_layout) { create(:layout, :video, site: site) }
    let!(:article_layout) { create(:layout, :article, site: site) }
    let(:response_body) { JSON.load(response.body) }

    context 'when no published videos' do
      it 'returns an empty array' do
        get '/en/videos/published'
        expect(response_body).to eql([])
      end
    end

    context 'when published videos' do
      let(:video_layout) { create(:layout, :video, site: site) }
      let!(:page) do
        object = create(:page,
                        label: 'Borrow',
                        slug: 'borrow',
                        site: site,
                        state: 'published',
                        layout: video_layout,
                        full_path: '/')
        object.blocks.create(identifier: 'content', content: '## title')
        object
      end

      before :each do
        create(:page,
               label: 'Borrow v2',
               slug: 'borrow-v2',
               site: site,
               state: 'draft',
               layout: video_layout,
               full_path: '/')
        create(:page,
               label: 'Borrow v3',
               slug: 'borrow-v3',
               site: site,
               state: 'published',
               layout: article_layout,
               full_path: '/')
      end

      it 'returns published videos' do
        get '/en/videos/published'
        expect(response_body.count).to eql(1)
      end

      it 'content is html' do
        get '/en/videos/published'
        expect(response_body[0]['blocks'][0]['content'])
          .to include('<h2 id="title">title</h2>')
      end
    end
  end

  describe 'GET /:locale/articles/published.json' do
    let!(:article_layout) { create(:layout, :article, site: site) }
    let(:response_body) { JSON.load(response.body) }

    context 'when no published articles' do
      it 'returns an empty array' do
        get '/en/articles/published'
        expect(response_body).to eql([])
      end
    end

    context 'when published articles' do
      let(:article_layout) { create(:layout, :article, site: site) }
      let!(:page) do
        object = create(:page,
                        label: 'Borrow',
                        slug: 'borrow',
                        site: site,
                        state: 'published',
                        layout: article_layout,
                        full_path: '/')
        object.blocks.create(identifier: 'content', content: '## title')
        object
      end

      before :each do
        create(:page,
               label: 'Borrow v2',
               slug: 'borrow-v2',
               site: site,
               state: 'draft',
               layout: article_layout,
               full_path: '/')
      end

      it 'returns published articles' do
        get '/en/articles/published'
        expect(response_body.count).to eql(1)
      end

      it 'content is html' do
        get '/en/articles/published'
        expect(response_body[0]['blocks'][0]['content'])
          .to include('<h2 id="title">title</h2>')
      end
    end
  end

  describe 'GET /:locale/articles/unpublished.json' do
    let!(:article_layout) { create(:layout, :article, site: site) }
    let(:response_body) { JSON.load(response.body) }

    context 'when no unpublished articles' do
      let(:video_layout) { create(:layout, :video, site: site) }

      before :each do
        object = create(:page,
                        label: 'Borrow',
                        slug: 'borrow',
                        site: site,
                        state: 'unpublished',
                        layout: video_layout,
                        full_path: '/')
        object.blocks.create(identifier: 'content', content: '## title')
        object
      end

      it 'returns an empty array' do
        get '/en/articles/unpublished'
        expect(response_body).to eql([])
      end
    end

    context 'when unpublished articles' do
      let(:article_layout) { create(:layout, :article, site: site) }
      let!(:page) do
        object = create(:page,
                        label: 'Borrow',
                        slug: 'borrow',
                        site: site,
                        state: 'unpublished',
                        layout: article_layout,
                        full_path: '/')
        object.blocks.create(identifier: 'content', content: 'stuff')
        object.revisions.create(
          data: {
            previous_event: 'published',
            event: 'unpublished',
            blocks_attributes: [
              { identifier: 'content', content: '## title' }
            ]
          }
        )
        object.update_column(:active_revision_id, object.revisions.first.id)
        object
      end

      before :each do
        create(:page,
               label: 'Borrow v2',
               slug: 'borrow-v2',
               site: site,
               state: 'published',
               layout: article_layout,
               full_path: '/')
      end

      it 'returns unpublished articles' do
        get '/en/articles/unpublished'
        expect(response_body.count).to eql(1)
      end

      it 'content is html' do
        get '/en/articles/unpublished'
        expect(response_body[0]['blocks'][0]['content']).to include('<p>stuff</p>')
      end
    end
  end

  describe 'GET /:locale/articles/:slug' do
    let(:state) { 'published' }
    let(:article_layout) { create(:layout, :article, site: site) }
    let!(:page) do
      create(:page, label: 'Borrow', slug: 'borrow', site: site, state: state, layout: article_layout, full_path: '/')
    end

    before do
      page.translation.update(label: 'Benthyciad', slug: 'benthyciad')
      get article_url
    end

    context 'when existing page' do
      let(:article_url) { '/en/articles/borrow' }
      let(:translations) { [{ 'label' => 'Benthyciad', 'link' => '/cy/articles/benthyciad', 'language' => 'cy' }] }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns page mirrors' do
        expect(response_body[:translations]).to eq(translations)
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

    context 'when does not pass any page type (API backwards compatibility)' do
      let(:article_url) { '/en/borrow' }

      it 'renders article resource' do
        expect(response_body).to include(label: 'Borrow', slug: 'borrow')
      end

      it 'returns successful response' do
        expect(response.status).to be 200
      end
    end

    context 'when does not pass any page type and slug' do
      let(:article_url) { '/en' }

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
        expect(response_body).to eq(message: 'Site "br" not found')
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

    context 'when inexistent page type' do
      let(:article_url) { '/en/inexistent_page_type/borrow' }

      it 'renders error message' do
        expect(response_body).to eq(message: 'Page type "inexistent_page_type" not supported')
      end

      it 'responds bad request' do
        expect(response.status).to be 400
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
