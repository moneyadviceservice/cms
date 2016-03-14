module RevisionData
  def self.load(revision)
    Loader.new(revision).to_hash
  end

  def self.dump(options)
    user = options.delete(:user)

    {
      author: {
        id:   user.id,
        name: user.name
      }
    }.merge(options)
  end

  class Loader
    attr_reader :revision

    delegate :id, :created_at, :data, to: :revision

    def initialize(revision)
      @revision = revision
    end

    def author
      data[:author][:name] if data[:author]
    end

    def text
      data[type.to_sym]
    end

    def type
      return 'event' if data[:event].present?

      if data[:note].present?
        'note'
      else
        'blocks_attributes'
      end
    end

    def to_hash
      {
        id:         id,
        author:     author,
        type:       type,
        text:       text,
        created_at: created_at
      }
    end
  end
end
