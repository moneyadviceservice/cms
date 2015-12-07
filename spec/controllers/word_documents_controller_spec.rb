RSpec.describe WordDocumentsController, type: :controller do
  include_context 'cms'

  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end

  describe 'create' do
    let(:filepath) { Rails.root.join('spec/fixtures/structured_doc.docx') }
    let(:content_type) { Rack::Mime.mime_type(File.extname(filepath)) }
    let(:document) { Rack::Test::UploadedFile.new(filepath, content_type) }

    it 'creates a new article with the word document contents' do
      post :create, word: { document: document }, format: 'js'

      expect(assigns(:doc)).to_not be_nil
      expect(assigns(:doc).to_markdown).to include('# Heading One')
    end
  end
end
