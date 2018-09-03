RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:headers) do
    {
      'HTTP_AUTHORIZATION' =>
        ActionController::HttpAuthentication::Token.encode_credentials(
          'mytoken'
        )
    }
  end
  let(:response_body) do
    JSON.parse(response.body)
  end
  subject(:documents) do
    response_body['documents']
  end

  describe 'GET /:locale/documents' do
    context 'when requesting all documents' do
      it 'returns all documents' do
        get '/api/en/documents', {}, headers
        expect(response.status).to be(200)
      end
    end

    context 'when requesting pages for pagination' do
      let!(:insight_page_titled_pensions) do
        create(:insight_page_titled_pensions, site: site)
      end
      let!(:uk_study_about_work_and_stress) do
        create(:uk_study_about_work_and_stress, site: site)
      end

      before do
        get '/api/en/documents', { page: page, per_page: 1 }, headers
      end

      context 'requesting first page' do
        let(:page) { 1 }

        it 'returns documents from first page' do
          expect(documents.first).to include('label' => 'pensions')
        end

        it 'returns meta information' do
          expect(response_body['meta'].symbolize_keys).to eq(
            results: 2,
            per_page: 1,
            page: 1,
            total_pages: 2
          )
        end
      end

      context 'requesting last page' do
        let(:page) { 2 }

        it 'returns documents from last page' do
          expect(documents.first).to include(
            'label' => 'Debt, stress and pay levels in the UK'
          )
        end

        it 'returns meta information' do
          expect(response_body['meta'].symbolize_keys).to eq(
            results: 2,
            per_page: 1,
            page: 2,
            total_pages: 2
          )
        end
      end
    end

    context 'when searching by page type' do
      let!(:english_article) do
        create(:english_article, site: site)
      end
      let!(:review_article) do
        create(
          :page,
          site: site,
          label: 'review label',
          layout: create(:layout, identifier: 'review')
        )
      end

      before do
        get '/api/en/documents', { document_type: ['review'] }, headers
      end

      it 'excludes other documents not within the page type' do
        expect(documents.size).to be(1)
      end

      it 'returns documents only of the requested page type' do
        expect(documents.first).to include(
          'label' => 'review label',
          'layout_identifier' => 'review'
        )
      end
    end

    context 'when searching by tag' do
      let!(:page_with_tag) do
        create(
          :page_with_tag,
          label: 'Page with tag',
          site: site,
          tag_name: 'pensions'
        )
      end
      let!(:page_without_tag) do
        create(:page, site: site)
      end
      let!(:page_with_a_different_tag) do
        create(:page_with_tag, site: site, tag_name: 'sorry-not-a-pensions')
      end

      context 'when searching an existent tag' do
        before do
          get '/api/en/documents', { tag: 'pensions' }, headers
        end

        it 'returns page with the same tag' do
          expect(documents.size).to be(1)
          expect(documents.first).to include(
            'label' => 'Page with tag'
          )
        end
      end

      context 'when search a non existent tag' do
        before do
          get '/api/en/documents', { tag: 'non-existent' }, headers
        end

        it 'returns empty documents' do
          expect(documents.size).to be_zero
        end
      end
    end

    context 'bad request' do
      let(:document_provider) { double }

      it 'returns a 400 status code' do
        allow(DocumentProvider)
          .to receive(:new)
          .and_return(document_provider)

        allow(document_provider)
          .to receive(:retrieve)
          .and_return(nil)

        get '/api/en/documents', {}, headers

        expect(response.status).to eq 400
      end
    end
  end
end
