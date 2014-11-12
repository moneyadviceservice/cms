module ReverseMarkdown
  def self.site=(site)
    @@site = site
  end

  def self.site
    @@site
  end
end
