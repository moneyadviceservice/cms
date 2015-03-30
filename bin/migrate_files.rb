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
  RACKSPACE_USERNAME = ENV['RACKSPACE_USERNAME']
  RACKSPACE_API_KEY  = ENV['RACKSPACE_API_KEY']
  BUCKET_NAME        = ENV['RACKSPACE_BUCKET_NAME']
  attr_reader :hippo_files

  def self.upload(hippo_files)
    new(hippo_files).upload
  end

  def initialize(hippo_files)
    @hippo_files = hippo_files
  end

  def upload
    hippo_files.each do |hippo_file|
      puts "Uploading #{hippo_file.filename}"
      puts hippo_file.blob

      #bucket.files.create(
      #  key:    hippo_file.filename,
      #  body:   hippo_file.blob,
      #  public: true
      #)
    end
  end

  def bucket
    connection.directories.find { |dir| dir.key == BUCKET_NAME }
  end

  def connection
    @connection ||= Fog::Storage.new(
      provider:           'Rackspace',
      rackspace_username: RACKSPACE_USERNAME,
      rackspace_api_key:  RACKSPACE_API_KEY,
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

  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

if options.file
  files =  HippoFileParser.parse(options.file)
  RackSpaceCDN.upload(files)
else
  puts 'You need to pass the Hippo asset xml file with --file [FILE].'
end
