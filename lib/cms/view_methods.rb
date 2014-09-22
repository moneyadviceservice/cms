module Cms
  module ViewMethods
    module Helpers
      def cms_mirror_options(object=nil)

        options = case object
        when ::Comfy::Cms::Layout
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_layout_path(m.site, m)]}
        when ::Comfy::Cms::Page
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_page_path(m.site, m)]}
        when ::Comfy::Cms::Snippet
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_snippet_path(m.site, m)]}
        else
          (::Comfy::Cms::Site.mirrored - [@site]).collect{|s| [s.label, url_for(params.merge(:site_id => s.id))]}
        end
        options = [[@site.label, request.fullpath]] + options

        if options.count > 1
          en = options.find {|o| o.first.match(/en/i) }
          cy = options.find {|o| o.first.match(/cy/i) }
        end

        [en, cy]
      end

      def highlighted_terms(content, term='')
        return truncated_content(content) if term.blank?
        highlight_term(truncated_content(content), term).html_safe
      end

      private

      def highlight_term(content, term)
        content.split(" ").map do |word|
          word.match(Regexp.new(term, true)) ? content_tag('b', word) : word
        end.join(" ")
      end

      def truncated_content(content, length=100)
        sanitize_content(content).truncate(length)
      end

      def sanitize_content(content)
        ActionView::Base.full_sanitizer.sanitize(Kramdown::Document.new(content).to_html)
      end
    end
  end

  ActionView::Base.send :include, Cms::ViewMethods::Helpers
end
