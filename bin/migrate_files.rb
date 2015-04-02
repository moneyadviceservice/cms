require 'bundler/setup'
require 'optparse'
require 'base64'
require 'ostruct'
require 'nokogiri'
require 'hippo_xml_parser'
require 'fog'
require 'pry'
require_relative '../lib/hippo_file_parser'
require_relative '../lib/rackspace_cdn'

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

if !options.file.nil? && options.username && options.key && options.bucket
  files =  HippoFileParser.parse(options.file)
  puts "Uploading #{files.size} files."
  rackspace = RackSpaceCDN.new(options)
  rackspace.upload(files)
  puts 'Done.'
  puts
  puts 'Files in the bucket:'
  rackspace.list_files
else
  puts 'Usage:'
  puts 'ruby bin/migrate_files -u rackspace_username -k rackspace_key -b bucket_name -f hippo_file.xml'
end
