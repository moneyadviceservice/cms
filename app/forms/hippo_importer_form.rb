Dir[Rails.root.join('lib/cms/hippo_importer/*.rb')].each { |f| require(f) }

class HippoImporterForm
  include ActiveModel::Model
  attr_accessor :hippo_file, :slugs, :site, :migration_type

  validates :hippo_file, :site, :slugs, presence: true
  validates :site, inclusion: { in: %w(en cy) }
  validates :migration_type, inclusion: {
    in: proc do
      Cms::HippoImporter::Base.descendants.map { |klass| klass.name.demodulize.underscore }
    end
  }, allow_blank: true
end
