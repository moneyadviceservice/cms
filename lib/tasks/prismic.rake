namespace :prismic do
  desc 'Show statistics for Prismic pages given a directory. Example: rake prismic:statistics[~/prismic_files]'
  task :statistics, [:dir] => :environment do |t, args|
    Prismic::Statistics.new(args[:dir]).call
  end

  desc 'Import all Evidence Hub prismic pages given a directory. Example: rake prismic:hub_import[~/prismic_files]'
  task :hub_import, [:dir] => :environment do |t, args|
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Prismic::HubImport.new(args[:dir]).call
  end
end

module Prismic
  class HubImport
    attr_reader :parser

    def initialize(dir)
      @parser = Prismic::Parser.new(dir)
    end

    def call
      @site = Comfy::Cms::Site.first

      ## Create the evidence types as CMS layouts
      parser.evidence_types.compact.uniq.each do |evidence_type|
        @site.layouts.find_or_create_by(
          label: evidence_type.titleize,
          identifier: evidence_type.parameterize
        )
      end

      parser.evidence_hub_pages.each do |evidence_hub_page|
        @site.pages.create do |cms_page|
          cms_page.label = evidence_hub_page.title
          cms_page.slug  = evidence_hub_page.title.parameterize

          cms_page.layout = Comfy::Cms::Layout.find_by(
            identifier: evidence_hub_page.evidence_type.parameterize
          )
          cms_page.blocks = evidence_hub_page.to_h.except(
            :type, :evidence_type, :new, :tag, :lang
          ).map do |key, value|
            Comfy::Cms::Block.new do |cms_block|
              cms_block.identifier = key
              cms_block.content = value
            end
          end
        end
      end
    end
  end
end

module Prismic
  class Parser
    def initialize(dir)
      @files = Dir[File.expand_path("#{dir}/*.json")]
    end

    def evidence_hub_pages
      pages.select { |page| page.type == 'hub-summary' }
    end

    def page_types
      pages.map { |page| page.type }
    end

    def evidence_types
      pages.map { |page| page.evidence_type }
    end

    def pages
      @pages ||= @files.map do |file|
        OpenStruct.new(JSON.parse(File.read(file)))
      end
    end
  end
end

module Prismic
  class Statistics
    attr_reader :parser, :report

    def initialize(dir)
      @parser = Prismic::Parser.new(dir)
      @report = { 'types' => {}, 'evidence types' => {} }
    end

    def call
      group(parser.page_types, name: 'types')
      group(parser.evidence_types, name: 'evidence types')

      puts @report
    end

    def group(data, name:)
      data.group_by(&:itself).each { |k, v| @report[name][k] = v.length }
    end
  end
end
