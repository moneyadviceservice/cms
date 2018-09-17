require_dependency ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'file.rb')

class Comfy::Cms::File
  def self.available_styles
    Comfy::Cms::File.new.file.styles
      .reject { |k, _| [:cms_thumb, :cms_medium].include? k }
      .map do |style, object|
      {
        style: style,
        width: object.geometry.split('x').first
      }
    end
  end
end
