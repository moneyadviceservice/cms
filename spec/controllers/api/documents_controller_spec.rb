RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:response_body) { JSON.load(response.body) }
  let(:documents) { response_body['documents'] }
  let(:meta_data) { response_body['meta'] }
  let(:url) { '/api/en/documents' }
  let(:review_layout)  { create :layout, identifier: 'review' }
  let(:insight_layout)  { create :layout, identifier: 'insight' }
  let!(:insight_page) { create(:insight_page_about_financial_wellbeing, site: site, layout: insight_layout) }
  let!(:insight_page_1) { create(:insight_page_about_debt, site: site, layout: insight_layout) }
  let!(:insight_page_2) { create(:insight_page_about_pensions, site: site, layout: insight_layout) }
  let!(:review_page_1) { create(:page, site: site, layout: review_layout) }

  before do
    allow_any_instance_of(PageSerializer)
      .to receive(:related_content).and_return({})

    get url, params
  end

  describe 'GET /:locale/documents' do
    context 'when all documents are requested' do
      let(:params) { {} }

      it 'returns all documents' do
        expect(meta_data['results']).to eq 4
        expect(documents.count).to eq 4
      end
    end

    context 'when documents of type insight are requested' do
      let(:params) { { document_type: 'insight' } }
      it 'returns all insight documents' do
        expect(meta_data['results']).to eq 3
        expect(documents.count).to eq 3
      end
    end
  end

  describe 'keyword search' do
    context 'when the document_type is specified' do
      context 'when a keyword is provided' do
        let(:params) { { document_type: 'insight', keyword: 'pension' } }

        it 'returns an array of documents which contain the keyword' do
          expect(meta_data['results']).to eq 1
          expect(documents.count).to eq 1
        end

      context 'when the keyword is not found' do
        let(:params) { { document_type: 'insight', keyword: 'nosuchterm' } }

        it 'returns an empty array' do
          expect(meta_data['results']).to eq 0
          expect(documents.count).to eq 0
        end
      end

      context 'when the search term is a phrase' do
        let(:params) do
          {
            document_type: 'insight', 
            keyword: 'Financial well being: the employee view' 
          }
        end

        it 'returns an array of documents which contain the phrase' do
          expect(meta_data['results']).to eq 1
          expect(documents.count).to eq 1
        end
      end
    end
  end
end
