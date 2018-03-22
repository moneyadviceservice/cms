class IndexDatabaseTask
  attr_reader :adapter, :category_indexer, :page_indexer

  PAGES_BATCH_SIZE = 500
  EXCLUDED_PAGES = %w(news action_plan universal_credit home_page footer)

  def initialize(
    adapter,
    category_indexer: Indexers::Category,
    page_indexer: Indexers::Page
  )
    @adapter = adapter
    @category_indexer = category_indexer
    @page_indexer = page_indexer
  end

  def run
    index_categories
    index_pages
  end

  def index_categories
    category_indexer.new(
      collection: categories,
      adapter: adapter
    ).index
  end

  def index_pages
    pages
    .find_in_batches(batch_size: PAGES_BATCH_SIZE) do |pages_collection|
      page_indexer.new(
        collection: pages_collection,
        adapter: adapter
      ).index
    end
  end

  def categories
    Comfy::Cms::Category.all
  end

  def pages
    Comfy::Cms::Page
      .includes(:blocks)
      .includes(:site)
      .includes(:layout)
      .joins(:layout)
      .where('comfy_cms_layouts.identifier NOT IN (?)', EXCLUDED_PAGES)
      .published
  end
end
