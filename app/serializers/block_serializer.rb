require 'active_model_serializers'

class BlockSerializer < ActiveModel::Serializer
  attributes :identifier, :content, :created_at, :updated_at

  private

  def content
    blocks = if render_content_directly?
      [{ "identifier" => "content", "content" => object.content}]
    else
      [{ "identifier" => "content", "content" => published_content.fetch(:content, '') }]
    end

    BlockComposer.new(blocks).to_html
  end

  def published_content
    published_block_attributes.find { |a| a[:identifier] == 'content' } || {}
  end

  def published_block_attributes
    (last_published_revision.try(:data) || {}).fetch(:blocks_attributes, [])
  end

  def last_published_revision
    object.blockable.revisions.find { |r| r.data[:previous_event] == 'published' }
  end

  def render_content_directly?
    scope == 'preview' || object.blockable.state == 'published' || past_scheduled_time?
  end

  def past_scheduled_time?
    object.blockable.state == 'scheduled' && object.blockable.scheduled_on <= Time.current
  end
end
