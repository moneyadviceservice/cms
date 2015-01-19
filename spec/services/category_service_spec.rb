RSpec.describe CategoryService do
  let(:category_params) { {} }
  let(:sub_category_params) { {} }
  let(:category) { double("Category") }

  subject { described_class.new(category, category_params, sub_category_params) }

  it 'update the category attributes' do
    expect(category).to receive(:update_attributes!)
    subject.update_category
  end

  context 'sub categories' do
    let(:sub_category_params) { { list_order_sub_categories: '1,2,3' } }

    it 'update the sub category order' do
      expect(category).to receive(:update_attributes!).with(category_params)
      expect(category).to receive(:update_attributes!).with(ordinal: 1)
      expect(category).to receive(:update_attributes!).with(ordinal: 2)
      expect(category).to receive(:update_attributes!).with(ordinal: 3)
      expect(Comfy::Cms::Category).to receive(:find).with('1').and_return(category)
      expect(Comfy::Cms::Category).to receive(:find).with('2').and_return(category)
      expect(Comfy::Cms::Category).to receive(:find).with('3').and_return(category)
      subject.update_category
    end
  end

  context 'categorization ordinal of pages' do
    let(:categorization) { double('categorization') }
    let(:sub_category_params) { { list_order_pages: '2,1' } }

    it 'update the page order' do
      expect(category).to receive(:update_attributes!).with(category_params)

      expect(categorization).to receive(:update_attributes!).with(ordinal: 1)
      expect(categorization).to receive(:update_attributes!).with(ordinal: 2)
      expect(Comfy::Cms::Categorization).to receive(:find_by).with(categorized_id: '2').and_return(categorization)
      expect(Comfy::Cms::Categorization).to receive(:find_by).with(categorized_id: '1').and_return(categorization)
      subject.update_category
    end
  end
end
