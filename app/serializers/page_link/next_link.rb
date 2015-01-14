module PageLink
  class NextLink < PageLink::Base
    def as_json
      navigation_link next_page
    end

    private

    def next_page
      fetch_adjacent_page do |index|
        index + 1
      end
    end
  end
end
