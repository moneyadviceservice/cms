class WordDocumentsController < Comfy::Admin::Cms::PagesController

  ACCEPTED_CONTENT_TYPES = [Rack::Mime.mime_type('.docx')]

  def create
    doc = WordDocument.new(document_params)
    @page.blocks.new(identifier: 'content', content: doc.to_s)

    render :action => :new
  end

  private

  def document_params
    params.fetch(:word).require(:document)
  end

end
