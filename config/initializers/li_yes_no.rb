module ReverseMarkdown
  module Converters
    class Div < Base
      def convert(node)
        div = "\n" << treat_children(node) << "\n"
        binding.pry if node.attributes["class"].try(:value) == 'callout'
        if node.attributes["class"].try(:value) == 'callout'
          "\n$=callout\n#{div}\n=$\n"
        elsif node.attributes["class"].try(:value) == 'add-action'
          "^#{div}^"
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
