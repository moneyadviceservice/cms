module API
  class DocumentsController < APIController
    before_action :find_site

    api :GET, '/:locale/documents'
    param :locale, String, required: true
    param :page_type, String, required: false
    param :keyword, String, required: false
    param :blocks, Array, required: false
    def index
      documents = DocumentProvider.new(
        current_site, 
        params[:document_type], 
        params[:keyword], 
        params[:blocks]
      ).retrieve

      render json: documents, meta: { results: documents.count }, root: 'documents'
    end
  end
end
