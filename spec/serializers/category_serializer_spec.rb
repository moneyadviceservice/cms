describe CategorySerializer do
  let(:child_categories) { nil }

  let(:category) do
    build(:category,
          label: 'test',
          title_en: 'en_title',
          title_cy: 'cy_title',
          description_en: 'description_en',
          description_cy: 'description_cy',
          third_level_navigation: true
         )
  end

  subject { described_class.new(category, scope: scope) }

  context 'english' do
    let(:scope) { 'en' }
    let(:expected_en) do
      {
        id: 'test',
        type: 'category',
        title: 'en_title',
        description: 'description_en',
        parent_id: '',
        third_level_navigation: true,
        contents: [],
        legacy_contents: [],
        legacy: false,
        images: {
          small: nil,
          large: nil
        },
        links: [],
        category_promos: [],
        url_path: 'en/categories/test'
      }
    end

    it 'returns the contents of the category' do
      expect(subject.as_json).to eq(expected_en)
    end
  end

  context 'welsh' do
    let(:scope) { 'cy' }
    let(:expected_cy) do
      {
        id: 'test',
        type: 'category',
        title: 'cy_title',
        description: 'description_cy',
        parent_id: '',
        third_level_navigation: true,
        contents: [],
        legacy_contents: [],
        legacy: false,
        images: {
          small: nil,
          large: nil
        },
        links: [],
        category_promos: [],
        url_path: 'cy/categories/test'
      }
    end

    it 'returns the contents of the category' do
      expect(subject.as_json).to eq(expected_cy)
    end
  end
end
