class DocumentProvider
  attr_reader :current_site, :document_type, :keyword, :filters, :tag, :order_by_date

  BLOCKS_TO_SEARCH = %w(content overview order_by_date).freeze
  FILTER_LIMIT = 26

  def initialize(params = {})
    @current_site = params[:current_site]
    @document_type = params[:document_type]
    @keyword = params[:keyword]
    @filters = params[:blocks]
    @tag = params[:tag]
    @order_by_date = params[:order_by_date]
  end

  def retrieve
    return if filters && filters.count > FILTER_LIMIT

    @documents = current_site.pages.published

    filter_by_document_type
    filter_by_keyword
    filter_by_tag
    filter_documents
    order_documents
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

  def filter_by_tag
    return @documents if tag.blank?

    @documents = @documents
                 .joins(:keywords).where('tags.value IN (?)', tag)
                 .uniq
  end

  def filter_documents
    return @documents if filters.blank?

    filters_to_hash.each do |filter, value|
      @documents = Comfy::Cms::Page
                   .unscoped
                   .select('DISTINCT(pages.id), pages.*').from("(#{@documents.to_sql}) as pages")
                   .joins("INNER JOIN comfy_cms_blocks ON comfy_cms_blocks.blockable_id = pages.id AND
          comfy_cms_blocks.blockable_type = 'Comfy::Cms::Page'")
                   .where('comfy_cms_blocks.identifier' => filter)
                   .where('comfy_cms_blocks.content' => value)
    end
    @documents
  end

  def filters_to_hash
    filters.each_with_object({}) do |filter, acc|
      if acc[filter[:identifier]]
        acc[filter[:identifier]] << filter[:value]
      else
        acc[filter[:identifier]] = [filter[:value]]
      end
    end
  end

  def order_documents
    if order_by_date == 'true'
      @documents.joins(:blocks)
                .where("comfy_cms_blocks.identifier = 'order_by_date'")
                .select("comfy_cms_pages.*, STR_TO_DATE(comfy_cms_blocks.content, '%Y-%m-%d') AS order_by_date")
                .reorder('order_by_date DESC')
                .uniq
    else
      @documents = @documents.reorder('created_at DESC')
    end
  end
end
