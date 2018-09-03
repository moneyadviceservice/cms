module PageBlocksHelper
  def alternate_content?(page)
    AlternatePageBlocksRetriever.new(page).blocks_attributes.present?
  end
end
