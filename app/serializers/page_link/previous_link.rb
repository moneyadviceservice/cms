module PageLink
  class PreviousLink < PageLink::Base
    def as_json
      navigation_link previous_page
    end

    private

    def previous_page
      fetch_adjacent_page do |index|
        index - 1
      end
    end
  end
end
