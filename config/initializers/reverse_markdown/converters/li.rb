module ReverseMarkdown
  module Converters
    class Li < Base
      def convert(node)
        content     = treat_children(node)
        indentation = indentation_for(node)
        prefix      = prefix_for(node)
        postfix     = postfix_for(node)
        "#{indentation}#{prefix}#{content}#{postfix}\n"
      end

      def postfix_for(node)
        return ' [/%]' if node.parent.parent.name == 'td'
        if node.attributes['class'].try(:value) == 'yes'
          ' [/y]'
        elsif node.attributes['class'].try(:value) == 'no'
          ' [/n]'
        else
          ''
        end
      end

      def prefix_for(node)
        if node.parent.name == 'ol'
          index = node.parent.xpath('li').index(node)
          "#{index.to_i + 1}. "
        else
          if node.parent.parent.name == 'td'
            '[%] '
          else
            if node.attributes['class'].try(:value) == 'yes'
              '[y] '
            elsif node.attributes['class'].try(:value) == 'no'
              '[n] '
            else
              '- '
            end
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
