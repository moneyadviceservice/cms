# TODO
# i. solutions for browsers without srcset support
#   On browsers without srcset support, the value of the src attribute will be
#   used as the image src [default image].
#

RSpec.describe ImageHelper, type: :helper do
  context 'browser with srcset support' do
    it 'builds an image tag with srcset attrs' do
      file = double(file_file_name: 'image-src.png', url: '/images/image-src.png')
      image_file = double(file: file)

      expect(helper.srcset_image_tag(image_file)).to eq('<img alt="" src="/images/image-src.png" srcset="image-src-1x.png 1x, image-src-2x.png 2x, image-src-3x.png 3x, image-src-4x.png 4x" />')
    end
  end
end
