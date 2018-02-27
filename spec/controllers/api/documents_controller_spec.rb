RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:response_body) { JSON.load(response.body) }
  let(:documents) { response_body['documents'] }
  let(:meta_data) { response_body['meta'] }
  let(:url) { "/api/en/documents#{params}" }

  before do
    allow_any_instance_of(PageSerializer)
      .to receive(:related_content).and_return({})
  end

  describe 'GET /:locale/documents' do
    let(:review_layout)  { create :layout, identifier: 'review' }
    let(:insight_layout)  { create :layout, identifier: 'insight' }

    let!(:insight_page_1) { create(:page, site: site, layout: insight_layout) }
    let!(:insight_page_2) { create(:page, site: site, layout: insight_layout) }
    let!(:review_page_1) { create(:page, site: site, layout: review_layout) }

    before { get url }

    context 'when all documents are requested' do
      let(:params) {''}

      it 'returns all documents' do
        expect(meta_data['results']).to eq 3
        expect(documents.count).to eq 3
      end
    end

    context 'when documents of type insight are requested' do
      let(:params) {'?document_type=insight'}

      it 'returns all insight documents' do
        expect(meta_data['results']).to eq 2
        expect(documents.count).to eq 2
      end
    end
  end
end
