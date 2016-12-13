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
    # /files/000/000/595/original/oregon-chai-what-is-chai-tea.jpg
    # /files/000/000/596/hp_thumb_png_1x/flower.png
    path_parts = path.split('/')
    id = path_parts[4].to_i
    Comfy::Cms::File.find(id).tap { |f| f.style = image_style(path_parts[5]) }
  end


  def image_style(paperclip_style)
     parts = paperclip_style.split('_')
     parts.size > 1 ? parts[1] : parts[0]
  end

  def srcset(cms_file)
    r = Regexp.new(cms_file.style)
    cms_file.file.styles.keys
      .select {|style|  style.to_s =~ r }
      .map do |style|
             density = style.to_s.split('_').last
             url = URI.join(ActionController::Base.asset_host, cms_file.file.url(style)).to_s
             "#{url} #{density}"
           end
      .join(', ')
  end
end
