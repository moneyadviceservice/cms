RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:document_provider) { double(DocumentProvider) }
  let(:documents) { [] }
  
  describe 'GET /:locale/documents' do
    context 'good request' do
      it 'returns all documents' do
        expect(DocumentProvider)
          .to receive(:new)
          .with(site, 'insight', 'insurance', nil)
          .and_return(document_provider)

        expect(document_provider)
          .to receive(:retrieve)
          .and_return(documents)

        get "/api/en/documents?document_type=insight&keyword=insurance"
      end
    end

    context 'bad request' do
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
