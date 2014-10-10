module ComfortableMexicanSofa::IsTaggable
  extend ActiveSupport::Concern

  module ClassMethods

    # Macro to enable association of tags to a model.
    # Creates the appropriate AR associations, scopes and instance methods.
    def is_taggable
      include ComfortableMexicanSofa::IsTaggable::InstanceMethods

      has_many :taggings,  as: :taggable
      has_many :tags, through: :taggings

      # Create an inverse association from ::Tag model to this taggable one.
      ::Tag.class_exec(self.name, self.name.demodulize.underscore.pluralize.to_sym) do |class_name, association_name|
        has_many association_name, class_name: class_name, through: :taggings, source: :taggable, source_type: class_name
      end
    end

  end

  module InstanceMethods
  end
end

ActiveRecord::Base.send(:include, ComfortableMexicanSofa::IsTaggable)
