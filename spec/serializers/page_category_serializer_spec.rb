describe PageCategorySerializer do
  let(:layout) { double("Layout", identifier: identifier) }

  let(:page) do
    double(
      'Page',
      id: 123,
      label: 'test',
      slug: 'slug',
      meta_description: 'meta',
      layout: layout
    )
  end

  subject { described_class.new(page) }

  context 'article' do
    let(:identifier) { 'article' }

    it 'returns the guide type' do
      expect(subject.as_json[:type]).to eq('guide')
    end
  end

  context 'tool' do
    let(:identifier) { 'tool' }

    it 'returns the tool type' do
      expect(subject.as_json[:type]).to eq('tool')
    end
  end
end
