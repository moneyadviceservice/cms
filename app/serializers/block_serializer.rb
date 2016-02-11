require 'active_model_serializers'

class BlockSerializer < ActiveModel::Serializer
  attributes :identifier, :content, :created_at, :updated_at

  private

  def content
    if identifier.start_with?('raw_')
      ContentComposer.new(block_content, RawParser).to_html
    else
      ContentComposer.new(block_content).to_html
    end
  end

  def block_content
    if render_content_directly?
      object.content
    else
      published_content
    end
  end

  def published_content
    hash = published_block_attributes.find { |a| a[:identifier] == identifier } || {}
    hash.fetch(:content, '')
  end

  def published_block_attributes
    (object.blockable.active_revision.try(:data) || {}).fetch(:blocks_attributes, [])
  end

  def render_content_directly?
    scope == 'preview' || object.blockable.state == 'published' || past_scheduled_time?
  end

  def past_scheduled_time?
    object.blockable.state == 'scheduled' && object.blockable.scheduled_on <= Time.current
  end
end
