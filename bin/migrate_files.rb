require 'bundler/setup'
require 'optparse'
require 'base64'
require 'ostruct'
require 'nokogiri'
require 'hippo_xml_parser'
require 'fog'
require 'pry'

class HippoFile < HippoXmlParser::Document
  def filename
    doc.parent['sv:name']
  end

  def blob
    binary_blob = find_property('hippo:text').value

    @blob ||= Base64.decode64(binary_blob)
  end

  def mime_type
    find_property('jcr:mimeType').value
  end
end

class HippoFileParser
  attr_reader :doc

  def self.parse(file)
    new(Nokogiri::XML(file)).all
  end

  def initialize(doc)
    @doc = doc
  end

  def all
    blobs = doc.xpath('//sv:property[@sv:type="Binary"][@sv:name="jcr:data"]')

    blobs.map { |blob| HippoFile.new(blob.parent) }
  end

  def mime_type
    find_property('jcr:mimeType').value
  end
end

class RackSpaceCDN
  attr_reader :hippo_files, :options

  def self.upload(hippo_files, options)
    new(hippo_files, options).upload
  end

  def initialize(hippo_files, options)
    @hippo_files = hippo_files
    @options = options
  end

  def upload
    hippo_files.each do |hippo_file|
      puts "Uploading #{hippo_file.filename}"
      hippo_file.blob

      bucket.files.create(
        key:    hippo_file.filename,
        body:   hippo_file.blob,
        public: true
      )
    end
  end

  def bucket
    connection.directories.find { |dir| dir.key == options.bucket }
  end

  def connection
    @connection ||= Fog::Storage.new(
      provider:           'Rackspace',
      rackspace_username: options.username,
      rackspace_api_key:  options.key,
      rackspace_auth_url: 'lon.auth.api.rackspacecloud.com'
    )
  end
end

options = OpenStruct.new

OptionParser.new do |opts|
  opts.on('--file [XML FILE]', 'Pass the Hippo xml asset file') do |filename|
    file = File.expand_path(filename)

    if File.exist? file
      options.file = File.read(file)
    else
      puts "File #{file} does not exist. :S"
    end
  end

  opts.on('-u [RACKSPACE USERNAME]', '--username', 'Pass the rackspace username') do |username|
    options.username = username
  end

  opts.on('-k [RACKSPACE API KEY]', '--key', 'Pass the rackspace key') do |key|
    options.key = key
  end

  opts.on('-b [RACKSPACE BUCKET NAME]', '--bucket', 'Pass the rackspace bucket name') do |bucket|
    options.bucket = bucket
  end

  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

if !options.file.empty? && options.username && options.key && options.bucket
  files =  HippoFileParser.parse(options.file)
  RackSpaceCDN.upload(files, options)
else
  puts 'In order to migrate from Hippo to Rackspace CDN you will need to run like these:'
  puts 'ruby bin/migrate_files -u rackspace_username -k rackspace_key -b bucket_name -f hippo_file.xml'
end
