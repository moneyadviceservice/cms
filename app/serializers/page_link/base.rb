module PageLink
  class Base
    def initialize(page)
      @page = page
    end

    private

    def navigation_link(adjacent_page)
      return {} if adjacent_page.nil?

      build_hash_for adjacent_page
    end

    def link_collection(pages)
      pages.map do |article|
        article = article.mirrors.first if current_locale == 'cy'
        build_hash_for article
      end
    end

    def build_hash_for(page_object)
      {
        title: page_object.label,
        path: page_object.fullest_path
      }
    end

    def current_locale
      @page.site.label
    end

    def fetch_adjacent_page
      pages = pages_from_first_category
      return nil if pages.nil?

      page_index = yield pages.index(@page)

      fetch_page(pages, page_index)
    end

    def pages_from_first_category
      return nil if @page.categories.empty?

      category = @page.categories.first
      @page.site.pages.in_category(category.id)
    end

    def fetch_page(pages, page_index)
      return nil if page_index < 0 || page_index >= pages.length

      pages[page_index]
    end
  end
end
