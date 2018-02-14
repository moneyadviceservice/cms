RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:response_body) { JSON.load(response.body) }

  before do
    allow_any_instance_of(PageSerializer)
      .to receive(:related_content).and_return({})
  end

  describe 'GET /:locale/documents?document_type=insight' do
    let(:review_layout)  { create :layout, identifier: 'review' }
    let(:insight_layout)  { create :layout, identifier: 'insight' }

    let!(:insight_page_1) { create(:page, site: site, layout: insight_layout) }
    let!(:insight_page_2) { create(:page, site: site, layout: insight_layout) }
    let!(:review_page_1) { create(:page, site: site, layout: review_layout) }

    context 'when all documents are requested' do
      it 'returns all documents' do
        get "/api/en/documents.json"
        expect(response_body.count).to eq 3
      end
    end

    context 'when documents of type insight are requested' do
      it 'returns all insight documents' do
        get "/api/en/documents.json?document_type=insight"
        expect(response_body.count).to eq 2
      end
    end
  end
end
