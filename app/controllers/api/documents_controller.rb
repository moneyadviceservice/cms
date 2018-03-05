module API
  class DocumentsController < APIController
    before_action :find_site

    BLOCKS_TO_SEARCH = %w[content overview]

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
        @documents = @documents
          .joins(:blocks)
          .where('comfy_cms_blocks.identifier' => BLOCKS_TO_SEARCH)
          .where('comfy_cms_pages.label LIKE ? OR comfy_cms_blocks.content LIKE ?', "%#{keyword}%", "%#{keyword}%")
      end
    end

  end
end
