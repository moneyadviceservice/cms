describe CategoryPromoSerializer do
  subject { described_class.new(category_promo) }

  let(:category_promo) do
    CategoryPromo.new(title: 'promo title',
                      description: 'promo description',
                      promo_type: 'blog',
                      locale: 'en',
                      url: 'https://example.com')
  end

  let(:expected) do
    {
      promo_type: 'blog',
      title: 'promo title',
      description: 'promo description',
      locale: 'en',
      url: 'https://example.com'
    }
  end

  it 'returns the contents of the category' do
    expect(subject.as_json).to eq(expected)
  end
end
