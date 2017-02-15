# TODO
# i. solutions for browsers without srcset support
#   On browsers without srcset support, the value of the src attribute will be
#   used as the image src [default image].
#

# TODO: Fix spec for setting image page for srcset files
#

#Failures:
#
#  1) ImageHelper browser with srcset support builds an image tag with srcset attrs
#     Failure/Error: expect(helper.srcset_image_tag(image)).to eq('<img alt="" src="/images/image-src.png" srcset="/images/image-src-1x.png 1x, /images/image-src-2x.png 2x, /images/image-src-3x.png 3x, /images/image-src-4x.png 4x" />')
#
#       expected: "<img alt=\"\" src=\"/images/image-src.png\" srcset=\"/images/image-src-1x.png 1x, /images/image-src-2x.png 2x, /images/image-src-3x.png 3x, /images/image-src-4x.png 4x\" />"
#            got: "<img alt=\"\" src=\"/images/image-src.png\" srcset=\"image-src-1x.png 1x, image-src-2x.png 2x, image-src-3x.png 3x, image-src-4x.png 4x\" />"
#
#       (compared using ==)
#     # ./spec/helpers/image_helper_spec.rb:14:in `block (3 levels) in <top (required)>'
#
#Finished in 0.03045 seconds (files took 14.99 seconds to load)
#1 example, 1 failure
#
#Failed examples:
#
#rspec ./spec/helpers/image_helper_spec.rb:9 # ImageHelper browser with srcset support builds an image tag with srcset attrs
#


RSpec.describe ImageHelper, type: :helper do
  context 'browser with srcset support' do
    it 'builds an image tag with srcset attrs' do
      # mocks Paperclip::Attachment
      file = double(url: '/images/image-src.png')
      image = double(file: file, file_file_name: 'image-src.png')

      expect(helper.srcset_image_tag(image)).to eq('<img alt="" src="/images/image-src.png" srcset="/images/image-src-1x.png 1x, /images/image-src-2x.png 2x, /images/image-src-3x.png 3x, /images/image-src-4x.png 4x" />')
    end
  end
end
