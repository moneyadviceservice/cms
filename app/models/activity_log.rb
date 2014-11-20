class ActivityLog
  include ActiveModel::Model
  attr_accessor :id, :author, :created_at, :type, :text

  def self.fetch(from: from)
    revisions = from.revisions.reorder(created_at: :asc)
    parse_method = method(:parse)

    revisions.map(&parse_method).reject(&:blocks_attributes?)
  end

  def self.parse(revision)
    new(RevisionData.load(revision))
  end

  def blocks_attributes?
    type == 'blocks_attributes'
  end

  def ==(other)
    id == other.id
  end
end
