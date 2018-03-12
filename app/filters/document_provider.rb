class DocumentProvider
  attr_reader :current_site, :document_type, :keyword, :filters

  BLOCKS_TO_SEARCH = %w[content overview]

  def initialize(current_site, document_type, keyword, filters)
    @current_site = current_site
    @document_type = document_type
    @keyword = keyword
    @filters = filters
  end

  def retrieve
    @documents = current_site.pages.published

    filter_by_type
    filter_by_keyword
    filter_documents
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

  def filter_documents
    return @documents if filters.blank?
    
    filters_to_hash.each do |filter, value|
      @documents = @documents
        .joins(:blocks)
        .where('comfy_cms_blocks.identifier ? = AND comfy_cms_blocks.content = ?', filter, value)
    end
  end

  def filters_to_hash
    filters.reduce({}) do |acc, filter|
      if acc[filter[:identifier]]
        acc[filter[:identifier]] << acc[filter[:value]]
      else
        acc[filter[:identifier]] = acc[filter[:value]]
      end
      acc
    end
  end
end
