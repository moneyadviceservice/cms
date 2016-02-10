require 'json'

class RedirectImporter
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def import!
    error_count = 0
    total = redirects.count

    redirects.each do |hash|
      source = hash['source']
      destination = hash['destination']

      ::PaperTrail.whodunnit = user

      unless (r = Redirect.create(source: source, destination: destination, redirect_type: 'permanent')).persisted?
        error_count += 1
        output_fail(source, destination, r)
      end
    end

    puts '====== ERRORS ====='
    puts "#{error_count} out of #{total}"
  end

  private

  def user
    @user ||= Comfy::Cms::User.first.id
  end

  def redirects
    @redirects ||= JSON.parse(file_contents)['redirects']
  end

  def file_contents
    File.open(path, 'r').read
  end

  def output_fail(source, destination, redirect)
    puts
    puts '===== FAILED ====='
    puts source
    puts destination
    puts redirect.errors.full_messages
  end
end
