require 'optparse'
require 'base64'
require 'nokogiri'
require 'ostruct'
require 'active_model'

class HippoFile
  include ActiveModel::Model
  attr_accessor :data
end

class HippoFileParser
  include ActiveModel::Model
  attr_accessor :file

  def data
    @data ||= ::Nokogiri::Slop(file)
  end

  def parse
    data.xpath('//sv:property[@sv:type="Binary"][@sv:name="jcr:data"]').map do |n|
      HippoFile.new(data: Base64.decode64(n.children.text))
    end
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
  files =  HippoFileParser.new(file: options.file).parse
  files.each { |file| puts file.data }
else
  puts 'You need to pass the Hippo asset xml file with --file [FILE].'
end
