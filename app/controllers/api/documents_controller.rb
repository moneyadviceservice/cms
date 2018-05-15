module API
  class DocumentsController < APIController
    PAGE_NUMBER = 1
    PER_PAGE = 20

    before_action :find_site

    api :GET, '/:locale/documents'
    param :locale, String, required: true
    param :page_type, String, required: false
    param :keyword, String, required: false
    param :blocks, Array, required: false
    def index
      if documents
        render json: paginated_documents, meta: meta_data, root: 'documents'
      else
        render json: { message: 'Bad request' }, status: 400
      end
    end

    private

    def documents
      @documents ||= DocumentProvider.new(
        current_site,
        params[:document_type],
        params[:keyword],
        params[:blocks]
      ).retrieve
    end

    def paginated_documents
      documents.page(page).per(per_page)
    end

    def meta_data
      {
        results: documents.size,
        page: page,
        per_page: per_page,
        total_pages: paginated_documents.total_pages
      }
    end

    def page
      Integer(params[:page] || PAGE_NUMBER)
    end

    def per_page
      Integer(params[:per_page] || PER_PAGE)
    end
  end
end
