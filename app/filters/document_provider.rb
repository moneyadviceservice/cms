class DocumentProvider
  attr_reader :current_site, :document_type, :keyword, :filters

  BLOCKS_TO_SEARCH = %w(content overview)
  FILTER_LIMIT = 26

  def initialize(current_site, document_type, keyword, filters)
    @current_site = current_site
    @document_type = document_type
    @keyword = keyword
    @filters = filters
  end

  def retrieve
    return if filters && filters.count > FILTER_LIMIT

    @documents = current_site.pages.published

    filter_by_document_type
    filter_by_keyword
    filter_documents
  end

  private

  def filter_by_document_type
    return @documents if document_type.blank?

    @documents = @documents.joins(:layout)
      .where('comfy_cms_layouts.identifier' => document_type)
  end

  def filter_by_keyword
    return @documents if keyword.blank?

    @documents = @documents
      .joins(:blocks)
      .where(
        'comfy_cms_pages.label LIKE ? OR
          (comfy_cms_blocks.content LIKE ? AND comfy_cms_blocks.identifier IN (?))',
          "%#{keyword}%", "%#{keyword}%", BLOCKS_TO_SEARCH
      ).uniq
  end

  def filter_documents
    return @documents if filters.blank?

    filters_to_hash.each do |filter, value|
      @documents = Comfy::Cms::Page
        .unscoped
        .select("pages.*").from("(#{@documents.to_sql}) as pages")
        .joins("INNER JOIN comfy_cms_blocks ON comfy_cms_blocks.blockable_id = pages.id AND
          comfy_cms_blocks.blockable_type = 'Comfy::Cms::Page'")
        .where('comfy_cms_blocks.identifier' => filter)
        .where('comfy_cms_blocks.content' => value)
    end

    @documents
  end

  def filters_to_hash
    filters.reduce({}) do |acc, filter|
      if acc[filter[:identifier]]
        acc[filter[:identifier]] << filter[:value]
      else
        acc[filter[:identifier]] = [filter[:value]]
      end
      acc
    end
  end
end
