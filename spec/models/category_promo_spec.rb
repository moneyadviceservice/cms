describe CategoryPromo do
  it { is_expected.to belong_to(:category) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_inclusion_of(:promo_type).in_array(CategoryPromo::PROMO_TYPES) }
    it { should validate_inclusion_of(:locale).in_array(%w(en cy)) }
  end
end
