class RackSpaceCDN
  attr_reader :options

  # @option options [String] :key Rackspace CDN API Key
  # @option options [String] :username Rackspace username
  # @option options [String] :bucket Rackspace bucket name
  #
  def initialize(options)
    @options = options
  end

  # Upload files to the Rackspace CDN.
  #
  # @param [Array<File>] files pass array of file object - responds #filename, #blob
  #
  def upload(files)
    files.each do |file|
      puts "Uploading '#{file.filename}'"

      bucket.files.create(
        key:    hippo_file.filename,
        body:   hippo_file.blob,
        public: true
      )
    end
  end

  def list_files
    bucket.files.each { |file| puts file.key }
  end

  def bucket
    @bucket ||= connection.directories.find { |dir| dir.key == options.bucket }
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