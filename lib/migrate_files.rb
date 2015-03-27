require 'bundler/setup'
require 'optparse'
require 'base64'
require 'ostruct'
require 'nokogiri'
require 'hippo_xml_parser'
require 'pry'

class HippoFile < HippoXmlParser::Document
  alias :filename :namespace

  def blob
    @blob ||= Base64.decode64(asset.find_property('hippo:text').doc.text)
  end

  def mime_type
    asset.find_property('jcr:mimeType').doc.text.strip
  end

  private

  def asset
    nodes.find { |node| node.find_node('hippogallery:asset') }.find_node('hippogallery:asset')
  end
end

class HippoFileParser < HippoXmlParser::Crawler
  def self.parse(file)
    new(Nokogiri::XML(file)).all
  end

  def type?(element)
    element.children.map do |e|
      if e.name == "property" && e["sv:name"] == "jcr:primaryType"

        e if e.children.select { |x| x.name == "value" }.any?
      end
    end.flatten.compact.first
  end

  def crawl(doc)
    if type?(doc)
      [HippoFile.new(doc)]
    else
      doc.children.map {|e| crawl(e) }
    end
  end
end

class RackSpaceCDN
  def self.upload(hippo_files)
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
  files.each { |file| puts file.filename; puts file.blob; puts file.mime_type }
  RackSpaceCDN.upload(files)
else
  puts 'You need to pass the Hippo asset xml file with --file [FILE].'
end
