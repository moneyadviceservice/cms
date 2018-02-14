module API
  class DocumentsController < APIController
    before_action :find_site

    def index
      @documents = current_site.pages.published

      filter_documents

      render json: @documents
    end

    private

    def document_type
      params[:document_type]
    end

    def filter_documents
      if document_type.present?
        @documents = @documents.joins(:layout)
          .where('comfy_cms_layouts.identifier' => document_type)
      end
    end
  end
end
