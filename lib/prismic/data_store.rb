module Prismic
  module DataStore
    def all(dir)
      files = Dir[File.expand_path("#{dir}/*.json")]
      files.map { |file| new(JSON.parse(File.read(file))) }.flatten
    end
  end
end
