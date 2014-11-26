require 'active_model_serializers'

class BlockSerializer < ActiveModel::Serializer
  attributes :identifier, :content, :created_at, :updated_at

  private

  def content
    return object.content if scope == 'preview' || object.blockable.state == 'published'
    published_content.fetch(:content, '')
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
end
