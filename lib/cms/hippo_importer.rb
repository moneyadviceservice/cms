module Cms
  module HippoImporter
    module_function

    def migrate(hippo_import_form)
      file = hippo_import_form.hippo_file.read
      slugs = hippo_import_form.slugs.split("\n")
      site = hippo_import_form.site
      klass = "Cms::HippoImporter::#{hippo_import_form.migration_type.camelize}".constantize
      importer = klass.new(data: file, docs: slugs, to: site)

      importer.import!
    end
  end
end
