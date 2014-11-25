RSpec.describe WordDocumentsController, type: :controller do
  include_context 'cms'

  describe 'create' do
    let(:filepath) { Rails.root.join('spec/fixtures/structured_doc.docx') }
    let(:content_type) { Rack::Mime.mime_type(File.extname(filepath)) }
    let(:document) { Rack::Test::UploadedFile.new(filepath, content_type) }

    it 'creates a new article with the word document contents' do
      # post :create, word: { document: document }

      # expect(assigns(:page).blocks.first.content).to_not be_nil
    end
  end
end
