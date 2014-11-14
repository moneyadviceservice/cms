module ReverseMarkdown
  module Converters
    class Div < Base
      def convert(node)
        div = "\n" << treat_children(node) << "\n"
        if node.attributes['class'].try(:value) == 'callout'
          h3_text = node.children.find {|c| c.name == 'h3'}.try(:text) || ""
          h3_text_capitalized = h3_text.strip.downcase.capitalize
          div.sub!(Regexp.new(h3_text.strip, true), h3_text_capitalized)
          div.sub!("??", "?")
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
