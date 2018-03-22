require Rails.root.join('lib/cms/index_database_task')

RSpec.describe IndexDatabaseTask do
  subject(:task) do
    described_class.new(
      adapter,
      category_indexer: category_indexer,
      page_indexer: page_indexer
    )
  end

  let(:adapter) { 'local' }
  let(:category_indexer) { double('CategoryIndexer') }
  let(:page_indexer) { double('PageIndexer') }

  describe '#run' do
    it 'index categories and pages' do
      expect(task).to receive(:index_categories)
      expect(task).to receive(:index_pages)
      task.run
    end
  end

  describe '#index_categories' do
    let!(:categories) do
      [create(:category), create(:category)]
    end

    it 'index all categories' do
      expect(category_indexer).to receive(:new).with(
        collection: categories,
        adapter: adapter
      ).and_return(category_indexer)
      expect(category_indexer).to receive(:index)
      task.index_categories
    end
  end

  describe '#index_pages' do
    let!(:pages) do
      [create(:page), create(:page)]
    end
    let!(:excluded_pages) do
      [
        create(:page, layout: create(:layout, :news)),
        create(:page, layout: create(:layout, :action_plan)),
        create(:page, layout: create(:layout, :universal_credit)),
        create(:page, layout: create(:layout, :home_page)),
        create(:page, layout: create(:layout, :footer))
      ]
    end

    it 'index selected pages' do
      expect(page_indexer).to receive(:new).with(
        collection: pages,
        adapter: adapter
      ).and_return(page_indexer)
      expect(page_indexer).to receive(:index)
      task.index_pages
    end
  end
end
