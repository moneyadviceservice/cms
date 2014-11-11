module ReverseMarkdown
  module Converters
    class Div < Base
      def convert(node)
        div = "\n" << treat_children(node) << "\n"
        if node.attributes['class'].try(:value) == 'callout'
          "\n$~callout #{div} ~$\n"
        elsif node.attributes['class'].try(:value) == 'collapsible-section'
          "\n$- #{div} -$\n"
        else
          div
        end
      end
    end

    register :div, Div.new
  end
end
