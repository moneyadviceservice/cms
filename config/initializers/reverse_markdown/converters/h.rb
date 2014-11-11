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
