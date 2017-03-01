# TODO
# i. solutions for browsers without srcset support
#   On browsers without srcset support, the value of the src attribute will be
#   used as the image src [default image].
#

RSpec.describe ImageHelper, type: :helper do
  context 'browser with srcset support' do
    it 'builds an image tag with srcset attrs' do
      image = FactoryGirl.create :file, id: 1, file_file_name: 'sample.png'

      expect(helper.srcset_image_tag(image)).to eq(%q{<img alt="" src="/files/000/000/001/original/sample.png" srcset="/files/000/000/001/extra_small/sample.png 1x, /files/000/000/001/small/sample.png 2x, /files/000/000/001/medium/sample.png 3x, /files/000/000/001/large/sample.png 4x" />})
    end
  end
end
