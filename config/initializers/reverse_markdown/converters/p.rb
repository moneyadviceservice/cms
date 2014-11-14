module ReverseMarkdown
  module Converters
    class P < Base
      def convert(node)
        if node.attributes['class'].try(:value) == 'intro'
          "\n\n" << '**' << treat_children(node).strip << '**' << "\n\n"
        else
          "\n\n" << treat_children(node).strip << "\n\n"
        end
      end
    end

    register :p, P.new
  end
end
