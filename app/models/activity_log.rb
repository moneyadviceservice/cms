class ActivityLog
  include ActiveModel::Model
  attr_accessor :id, :author, :created_at, :type, :text

  def self.fetch(from: from)
    revisions = from.revisions.reorder(created_at: :asc).reject do |revision|
      revision.data[:event].blank? && revision.data[:note].blank?
    end

    revisions.collect do |revision|
      parse(revision)
    end
  end

  def self.parse(revision)
    new(RevisionData.load(revision))
  end

  def ==(other)
    id == other.id
  end
end
