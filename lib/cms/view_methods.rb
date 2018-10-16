module Cms
  module ViewMethods
    module Helpers
      def highlighted_terms(content, term = '')
        return content if term.blank?

        highlight_term(content, term).html_safe
      end

      private

      def highlight_term(content, term)
        content.to_s.split(' ').map do |word|
          word.match(Regexp.new(term, true)) ? content_tag('b', word) : word
        end.join(' ')
      end
    end
  end

  ActionView::Base.send :include, Cms::ViewMethods::Helpers
end
