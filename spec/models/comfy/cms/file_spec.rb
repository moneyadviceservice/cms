RSpec.describe Comfy::Cms::File do
  describe '#styles' do
    context 'various dimensions' do
      {
        extra_small: '390x244',
        small: '485x304',
        medium: '900x564',
        large: '1350x846'
      }.each do |size, dimension|
        it "produces #{size} files with #dimensions of {dimension}" do
          expect(subject.file.styles.keys).to include(size)
          expect(subject.file.styles[size].geometry).to eq(dimension)
        end
      end
    end
  end
end
