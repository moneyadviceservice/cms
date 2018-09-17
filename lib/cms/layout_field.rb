# This class handles the comfortable mexican sofa tags
# that the Cms::FormBuilder < ComfortableMexicanSofa::FormBuilder
# requires for rendering the inputs for the form.
#
# The comfortable mexican sofa tags are the objects better understood to be
# the fields on the form.
# A comfortable mexican sofa tags is an object that
# responds to  `.identifier` and `.blockable`
#
# identifier is the field e.q. contact_details
# blockable is usually the page object
#
# @example
# ComfortableMexicanSofa::Tag::PageRichText.new
#
class Cms::LayoutField
  def self.map(collection)
    # stags_size = collection.map { |tag| tag.respond_to?(:collection_params) ? tag.collection_params.size : nil }.compact.sum + collection.size
    collection.map do |tag|
      if tag.respond_to?(:collection_params)
        tag.collection_params.each_with_index.map do |element, index|
          collection_check_boxes = ComfortableMexicanSofa::Tag::CollectionCheckBoxes.new.tap do |collection_check_boxes|
            collection_check_boxes.identifier = tag.identifier
            collection_check_boxes.element = element
            collection_check_boxes.field_index = index
          end

          new(collection_check_boxes)
        end
      else
        new(tag)
      end
    end.flatten
  end

  attr_reader :tag

  def initialize(tag)
    @tag = tag
  end

  def input_tag_for(form_builder:, index:)
    form_builder.send(input_tag_method, tag, index)
  end

  private

  def input_tag_method
    @tag.class.to_s.demodulize.underscore
  end
end
