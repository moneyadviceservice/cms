class HippoFile < HippoXmlParser::Document
  def filename
    doc.parent['sv:name']
  end

  def blob
    binary_blob = (find_property('hippo:text') || find_property('jcr:data')).value

    @blob ||= Base64.decode64(binary_blob)
  end

  def mime_type
    find_property('jcr:mimeType').value
  end

  def ==(other)
    filename == other.filename
  end

  def inspect
    "#<#{self.class}:#{object_id} @filename='#{filename}' @blob='#{blob[0..10]}...'>"
  end
end
