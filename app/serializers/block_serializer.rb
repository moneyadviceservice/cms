require 'active_model_serializers'

class BlockSerializer < ActiveModel::Serializer
  attributes :identifier, :content, :created_at, :updated_at
  CONTENT_IDENTIFIER = 'content'.freeze

  def content
    block = if object.identifier == CONTENT_IDENTIFIER
              BlocksRetriever.new(object, scope).retrieve || return
            else
              object
            end

    if block[:processed_content].present?
      Rails.logger.info("Cache HIT for #{page.slug}")
      block[:processed_content]
    else
      Rails.logger.info("Cache MISS for #{page.slug}")
      convert_markdown_to_html(block)
    end
  end

  def page
    object.blockable
  end

  private

  def locale
    page.site.path
  end

  def convert_markdown_to_html(block)
    if identifier.start_with?('raw_')
      ContentComposer.new(locale, block[:content], RawParser).to_html
    else
      ContentComposer.new(locale, block[:content]).to_html
    end
  end
end
