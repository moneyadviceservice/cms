class DocumentProvider
  attr_reader :current_site, :document_type, :keyword

  BLOCKS_TO_SEARCH = %w[content overview]

  def initialize(current_site, document_type, keyword)
    @current_site = current_site
    @document_type = document_type
    @keyword = keyword
  end

  def retrieve
    @documents = current_site.pages.published

    filter_by_type
    filter_by_keyword
  end

  private

  def filter_by_type
    return @documents if document_type.blank?
    
    @documents = @documents.joins(:layout)
        .where('comfy_cms_layouts.identifier' => document_type)

  end

  def filter_by_keyword
    return @documents if keyword.blank?
   
    @documents = @documents
      .joins(:blocks)
      .where('comfy_cms_blocks.identifier' => BLOCKS_TO_SEARCH)
      .where('comfy_cms_pages.label LIKE ? OR comfy_cms_blocks.content LIKE ?', "%#{keyword}%", "%#{keyword}%").uniq
  end
end
