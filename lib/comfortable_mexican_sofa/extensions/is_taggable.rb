module ComfortableMexicanSofa::IsTaggable
  extend ActiveSupport::Concern

  module ClassMethods

    # Macro to enable association of keywords to a model.
    # Comfy already define #tags and #tags= methods in some models, so let's call :keywords to the Tag associated instances
    # of a model to avoid naming collisions!!!
    # Creates the appropriate AR associations, scopes and instance methods.
    def is_taggable
      include ComfortableMexicanSofa::IsTaggable::InstanceMethods
      has_many :taggings,  as: :taggable
      has_many :keywords, through: :taggings, class_name: 'Tag', foreign_key: 'tag_id', source: :tag
      accepts_nested_attributes_for :keywords
      a_tag_has_many_of_these_through_taggings
    end


    private

      # Create an inverse association from ::Tag model to this taggable one.
      def a_tag_has_many_of_these_through_taggings
        ::Tag.class_exec(name, name.demodulize.underscore.pluralize.to_sym) do |class_name, association_name|
          has_many association_name, class_name: class_name, through: :taggings, source: :taggable, source_type: class_name
        end
      end

  end


  module InstanceMethods

    # The list of tag_ids in string format.
    def keywords_attributes
      keyword_ids.map(&:to_s)
    end

    # Method to reset the tags of taggable item based in a form params.
    def keywords_attributes=(new_keyword_ids)
      valid_new_keyword_ids = new_keyword_ids.find_all(&:present?).map(&:to_i)
      current_keyword_ids   = self.keyword_ids
      keyword!   keyword_ids: (valid_new_keyword_ids - current_keyword_ids)
      unkeyword! keyword_ids: (current_keyword_ids - valid_new_keyword_ids)
    end


    private

      def keyword!(keyword_ids:)
        keyword_ids.each {|id| taggings.create(tag_id: id)}
      end

      def unkeyword!(keyword_ids:)
        taggings.where(tag_id: keyword_ids).each(&:destroy)
      end
  end
end

ActiveRecord::Base.send(:include, ComfortableMexicanSofa::IsTaggable)
