module ReverseMarkdown
  module Converters
    class Tr < Base
      def convert(node)
        content = treat_children(node).rstrip
        result  = "|#{content}\n"
        table_header_row?(node) ? result + underline_for(node) : result
      end

      def table_header_row?(node)
        node.element_children.all? {|child| child.name.to_sym == :th} ||
        node.parent.children.index(node) == 1
      end

      def underline_for(node)
        "| " + (['---'] * node.element_children.size).join(' | ') + " |\n"
      end
    end

    register :tr, Tr.new
  end
end

module ReverseMarkdown
  module Converters
    class Div < Base
      def convert(node)
        div = "\n" << treat_children(node) << "\n"
        if node.attributes["class"].try(:value) == 'callout'
          "\n$~callout #{div} ~$\n"
        elsif node.attributes["class"].try(:value) == 'collapsible-section'
          "\n$- #{div} -$\n"
        else
          div
        end
      end
    end

    register :div, Div.new
  end
end

module ReverseMarkdown
  module Converters
    class H < Base
      def convert(node)
        prefix = '#' * node.name[/\d/].to_i
        if node.attributes['class'].try(:value) == 'collapsible'
          ["\n", '$= ', treat_children(node), ' =$',  "\n"].join
        else
          ["\n", prefix, ' ', treat_children(node), "\n"].join
        end
      end
    end
    register :h2, H.new
  end
end

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
            " ^[#{name}](#{href}#{title})^"
          else
            name
          end
        else
          href = ::LinkLookup.new.find(href) unless href.match("/")
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

module ReverseMarkdown
  module Converters
    class Ul < Base
      def convert(node)
        ul = "\n" << treat_children(node)
        if node.attributes["class"].try(:value) == 'yes-no'
          "\n$yes-no\n#{ul}\n$end\n"
        else
          ul
        end
      end
    end

    register :ul, Ul.new
  end
end

module ReverseMarkdown
  module Converters
    class Li < Base
      def convert(node)
        content     = treat_children(node)
        indentation = indentation_for(node)
        prefix      = prefix_for(node)
        "#{indentation}#{prefix}#{content}\n"
      end

      def prefix_for(node)
        if node.parent.name == 'ol'
          index = node.parent.xpath('li').index(node)
          "#{index.to_i + 1}. "
        else
          if node.attributes["class"].try(:value) == 'yes'
            '[y] '
          elsif node.attributes["class"].try(:value) == 'no'
            '[n] '
          else
            '- '
          end
        end
      end

      def indentation_for(node)
        length = node.ancestors('ol').size + node.ancestors('ul').size
        '  ' * [length - 1, 0].max
      end
    end

    register :li, Li.new
  end
end
