module API
  class DocumentsController < APIController
    before_action :find_site

    api :GET, '/:locale/documents'
    param :locale, String, required: true
    param :page_type, String, required: false
    param :keyword, String, required: false
    def index
      @documents = current_site.pages.published

      filter_documents

      render json: @documents, meta: { results: @documents.count }, root: 'documents'
    end

    private

    def document_type
      params[:document_type]
    end

    def keyword
      params[:keyword]
    end

    def filter_documents
      if document_type.present?
        @documents = @documents.joins(:layout)
          .where('comfy_cms_layouts.identifier' => document_type)
      end

      if keyword.present?
        @documents = @documents.with_content_like(keyword)
      end
    end

  end
end
