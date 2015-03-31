RSpec.describe HippoFileParser do
  describe '.parse' do
    let(:file) { File.read(Rails.root.join('spec', 'fixtures', 'hippo-assets.xml')) }
    subject(:parse) { HippoFileParser.parse(file) }
    let(:hippo_file) do
      double(
        'HippoFile',
        filename: 'mas-a4-sale-and-rent-back-schemes-april-2013.pdf'
      )
    end

    it 'returns hippo files object' do
      expect(parse).to include(hippo_file)
    end
  end
end
