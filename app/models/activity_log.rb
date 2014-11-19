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
    revision_type = revision_data_type(revision)
    new(
      id:         revision.id,
      author:     revision.data[:author][:name],
      created_at: revision.created_at,
      type:       revision_type,
      text:       revision.data[revision_type.to_sym]
    )
  end

  def self.revision_data_type(revision)
    return 'event' if revision.data[:event].present?

    'note' if revision.data[:note].present?
  end

  def ==(other)
    id == other.id
  end
end
