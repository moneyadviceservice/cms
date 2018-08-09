module World
  module Editor
    def fill_editor_with(text, mode: :layout)
      case mode
      when :layout
        editor_element = edit_page.editor_default
      when :advanced
        edit_page.edit_in_markdown.trigger('click')
        editor_element = edit_page.content
      end

      editor_element.tap do |node|
        node.native.trigger('click')
        node.text.length.times { node.native.send_key(:backspace) }
        node.native.send_keys(text)
      end
    end
  end
end

World(World::Editor)
