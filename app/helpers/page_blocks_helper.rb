module PageBlocksHelper
  def has_alternate_content?(page)
    AlternatePageBlocksRetriever.new(page).blocks_attributes.present?
  end
end
