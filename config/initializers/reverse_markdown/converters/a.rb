module ReverseMarkdown
  module Converters
    class A < Base
      def convert(node)
        name  = treat_children(node)
        href  = node['href']
        title = extract_title(node)
        link = link_from(node, href, name, title)

        if node.attributes['data-type'].try(:value) == 'action'
          "^#{link}^"
        else
          link
        end
      end

      private

      def link_from(node, href, name, title)
        if href.to_s.start_with?('#') || href.to_s.empty? || name.empty?
          external_link(node, name, href, title)
        else
          internal_link(name, href, title)
        end
      end

      def external_link(node, href, name, title)
        data_action = node.attributes['data-action-id'].try(:value)
        if data_action
          href, name = ::LinkLookup.new.find_external(data_action.to_i, ReverseMarkdown.site.label.to_sym)
          " ^[#{name}](#{href}#{title}){:target='_blank'}^"
        else
          name
        end
      end

      def internal_link(name, href, title)
        href = ::LinkLookup.new.find(href, ReverseMarkdown.site.label) unless href.match('/')
        if href.match(/http/) && !href.match(/moneyadviceservice/)
          " [#{name}](#{href}#{title}){:target='_blank'}"
        else
          " [#{name}](#{href}#{title})"
        end
      end
    end

    register :a, A.new
  end
end
