RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  describe 'GET /:locale/documents' do
    context 'when requesting all documents' do
      it 'returns all documents' do
        get '/api/en/documents'
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
      let(:response_body) do
        JSON.parse(response.body)
      end
      subject(:documents) do
        response_body['documents']
      end

      before do
        get '/api/en/documents', page: page, per_page: 1
      end

      context 'requesting first page' do
        let(:page) { 1 }

        it 'returns documents from first page' do
          expect(documents.first).to include('label' => 'pensions')
        end

        it 'returns meta information' do
          expect(response_body['meta'].symbolize_keys).to eq({
            results: 2,
            per_page: 1,
            page: 1,
            total_pages: 2
          })
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
          expect(response_body['meta'].symbolize_keys).to eq({
            results: 2,
            per_page: 1,
            page: 2,
            total_pages: 2
          })
        end
      end
    end

    context 'bad request' do
      let(:document_provider) { double }

      it 'returns a 400 status code' do
        allow(DocumentProvider)
          .to receive(:new)
          .with(site, nil, nil, nil)
          .and_return(document_provider)

        allow(document_provider)
          .to receive(:retrieve)
          .and_return(nil)

        get "/api/en/documents"

        expect(response.status).to eq 400
      end
    end
  end
end
