class WordDocumentsController < Comfy::Admin::Cms::PagesController

  ACCEPTED_CONTENT_TYPES = [Rack::Mime.mime_type('.docx')]

  def create
    @doc = WordDocument.new(document_params)

    respond_to do |f|
      f.js
    end
  end

  private

  def document_params
    params.fetch(:word).require(:document)
  end

end
