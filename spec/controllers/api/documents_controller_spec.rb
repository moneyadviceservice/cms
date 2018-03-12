RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:document_provider) { double(DocumentProvider) }
  let(:documents) { [] }
  
  describe 'GET /:locale/documents' do
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
end
