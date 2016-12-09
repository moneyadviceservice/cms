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
    id = path.split('/')[4].to_i
    Comfy::Cms::File.find(id)
  end

  def srcset(cms_file)
    cms_file.file.styles.keys
      .map do |style|
             density = style.to_s.split('_').last
             url = URI.join(ActionController::Base.asset_host, cms_file.file.url(style)).to_s
             "#{url} #{density}"
           end
      .join(', ')
  end
end
