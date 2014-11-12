module ReverseMarkdown
  module Converters
    class A < Base
      def convert(node)
        name  = treat_children(node)
        href  = node['href']
        title = extract_title(node)
        link = if href.to_s.start_with?('#') || href.to_s.empty? || name.empty?
          data_action = node.attributes['data-action-id'].try(:value)
          if data_action
            href, name = ::LinkLookup.new.find_external(data_action.to_i, ReverseMarkdown.site.label.to_sym)
            " ^[#{name}](#{href}#{title}){:target='_blank'}^"
          else
            name
          end
        else
          href = ::LinkLookup.new.find(href) unless href.match('/')
          " [#{name}](#{href}#{title})"
        end

        if node.attributes['data-type'].try(:value) == 'action'
          "^#{link}^"
        else
          link
        end
      end
    end

    register :a, A.new
  end
end
