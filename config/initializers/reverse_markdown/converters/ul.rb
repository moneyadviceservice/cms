module ReverseMarkdown
  module Converters
    class Ul < Base
      def convert(node)
        ul = "\n" << treat_children(node)
        if node.parent.name == 'td'
          "$bullet #{ul.strip} $point "
        elsif node.attributes["class"].try(:value) == 'yes-no'
          "\n$yes-no\n#{ul}\n$end\n"
        else
          ul
        end
      end
    end

    register :ul, Ul.new
  end
end
