RSpec.describe CategoryMirror do
  let(:categories) { [create(:category), create(:category)] }
  let(:page) { create(:page) }

  subject { described_class.new }

  before do
    subject.assign_categories_to_mirrors(categories, [page])
  end

  it 'assigns the categories to a page' do
    expect(page.categories).to eq(categories)
  end
end
