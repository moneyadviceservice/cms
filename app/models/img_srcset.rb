# coding: utf-8
require 'nokogiri'

class ImgSrcset
  attr_reader :source, :images, :doc

  def initialize(_, source)
    @source    = source
    @doc       = Nokogiri::HTML.fragment(source)
    @images    = @doc.css('img')
    freeze
  end

  def call
    images.each do |img|
      file = image_file(img['src'])
      img['srcset'] = srcset(file)
    end
    doc.to_s
  end

  private

  def image_file(path)
    id, style = path.split('/')[-3..-2]
    Comfy::Cms::File.find(id).tap { |f| f.style = image_style(style) }
  end


  def image_style(paperclip_style)
     parts = paperclip_style.split('_')
     parts.size > 1 ? parts[1] : parts[0]
  end

  def srcset(cms_file)
    r = Regexp.new(cms_file.style)
    cms_file.file.styles.keys
      .map!(&:to_s)
      .select { |style| style =~ r }
      .map!   { |style| "#{image_url(cms_file, style)} #{density(style)}" }
      .join(', ')
  end

  def image_url(cf, style)
    URI.join(ActionController::Base.asset_host, cf.file.url(style)).to_s
  end

  def density(style)
    style.split('_').last
  end
end
