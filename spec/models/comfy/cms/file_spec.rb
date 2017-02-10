RSpec.describe Comfy::Cms::File do
  describe '#styles' do
    context 'various dimensions' do
      {
        extra_small: '553x346',
              small: '766x480',
             medium: '1110x600',
              large: '1440x902'
      }.each do |size, dimension|
        it "produces #{size} files with #dimensions of {dimension}" do
          expect(subject.file.styles.keys).to include(size)
          expect(subject.file.styles[size].geometry).to eq(dimension)
        end
      end
    end
  end
end
