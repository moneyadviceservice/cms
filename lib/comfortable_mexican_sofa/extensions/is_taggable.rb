module ComfortableMexicanSofa
  module IsTaggable
    module DSL
      extend ActiveSupport::Concern

      module ClassMethods
        # Macro to enable association of keywords to a model.
        # Comfy already define #tags and #tags= methods in some models, so let's call :keywords to the Tag associated
        # instances of a model to avoid naming collisions!!!
        # Creates the appropriate AR associations, scopes and instance methods.
        def is_taggable # rubocop:disable Style/PredicateName
          include ComfortableMexicanSofa::IsTaggable::ModelMethods
        end
      end
    end

    module ModelMethods
      extend ActiveSupport::Concern

      included do
        # -- Virtual Attributes -----------------------------------------------
        attr_accessor :mirrored_with_taggings
        alias_method :mirrored_with_taggings?, :mirrored_with_taggings

        # -- Relationships ----------------------------------------------------
        has_many :taggings, as: :taggable, dependent: :destroy, validate: false
        has_many :keywords, through: :taggings, class_name: 'Tag', foreign_key: 'tag_id', source: :tag
        accepts_nested_attributes_for :keywords
        a_tag_has_many_of_these_through_taggings

        # -- Callbacks --------------------------------------------------------
        after_save :sync_mirrors_with_taggings
      end

      module ClassMethods
        private

        # Create an inverse association from ::Tag model to this taggable one.
        def a_tag_has_many_of_these_through_taggings
          ::Tag.class_exec(name, name.demodulize.underscore.pluralize.to_sym) do |class_name, association_name|
            has_many association_name, through: :taggings,
                                       class_name:  class_name,
                                       source:      :taggable,
                                       source_type: class_name
          end
        end
      end

      # The list of tag_ids in string format.
      def keywords_attributes
        keyword_ids.map(&:to_s)
      end

      # Method to reset the tags of taggable item based in a form params.
      def keywords_attributes=(new_keyword_ids)
        self.mirrored_with_taggings = true
        assign_new_keywords!(new_keyword_ids: new_keyword_ids)
      end

      # New keywords for this item. Remove old ones, create new ones and keep the still valid ones.
      def assign_new_keywords!(new_keyword_ids:)
        valid_new_keyword_ids = new_keyword_ids.find_all(&:present?).map(&:to_i)
        current_keyword_ids   = keyword_ids
        keyword! keyword_ids: (valid_new_keyword_ids - current_keyword_ids)
        unkeyword! keyword_ids: (current_keyword_ids - valid_new_keyword_ids)
      end

      private

      # Associates a tag to this item.
      def keyword!(keyword_ids:)
        action = mirrored_with_taggings? ? :build : :create
        keyword_ids.each { |id| taggings.send(action, tag_id: id) }
      end

      # Disassociates a tag to this item.
      def unkeyword!(keyword_ids:)
        taggings.where(tag_id: keyword_ids).each(&:destroy)
      end

      # Callbacks

      # Synchorize the taggings of this item with the ones in its mirrors. So all of them
      # are associated to the same tags
      def sync_mirrors_with_taggings
        return unless mirrored_with_taggings?
        mirrors.each { |mirror| mirror.assign_new_keywords!(new_keyword_ids: keywords.map(&:id)) }
      end
    end
  end
end

ActiveRecord::Base.send(:include, ComfortableMexicanSofa::IsTaggable::DSL)
