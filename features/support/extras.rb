def fill_content_editable(selector, options = {})
  page.find(selector).tap do |node|
    node.native.trigger('click')

    if options[:clear_first]
      node.text.length.times { node.native.send_key(:Backspace) }
    end

    node.native.send_keys(options[:with])
  end
end
