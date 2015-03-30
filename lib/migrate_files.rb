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
    @blob ||= Base64.decode64(asset.find_property('hippo:text').value)
  end

  def mime_type
    asset.find_property('jcr:mimeType').value
  end

  private

  def asset
    nodes.first
  end
end

class HippoFileParser < HippoXmlParser::Crawler
  def self.parse(file)
    new(Nokogiri::XML(file)).all
  end

  def type?(element)
    assets(element)
  end

  def assets(element)
    files = element.children.map do |e|
      if e['sv:name'] =~ /[\w]*\.[\w]*/
        e.children.select { |x| x['sv:name'] =~ /[\w]*\.[\w]*/ }
      end
    end

    files.flatten.compact.first
  end

  def crawl(doc)
    if type?(doc)
      [HippoFile.new(assets(doc))]
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
  files.each { |file| puts file.filename; puts file.mime_type }
  RackSpaceCDN.upload(files)
else
  puts 'You need to pass the Hippo asset xml file with --file [FILE].'
end
