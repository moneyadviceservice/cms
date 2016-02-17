RSpec.describe Cms::PageBuilder do
  let!(:site)   { create(:site) }
  let!(:article_layout) { create(:layout, identifier: 'article', site: site) }
  let!(:home_page_layout) { create(:layout, identifier: 'home_page', site: site) }

  describe '.add_example_article!' do
    before { Cms::PageBuilder.add_example_article! }

    it 'adds a page' do
      expect(Comfy::Cms::Page.count).to eq(1)
    end

    it 'adds a page using the "article" layout' do
      expect(Comfy::Cms::Page.first.layout).to eq(article_layout)
    end
  end

  describe '.add_home_page!' do
    let(:page) { Comfy::Cms::Page.first }

    before { Cms::PageBuilder.add_home_page! }

    it 'adds a page' do
      expect(Comfy::Cms::Page.count).to eq(1)
    end

    it 'adds a page using the "home_page" layout' do
      expect(page.layout).to eq(home_page_layout)
    end

    it 'adds the page to the english site' do
      expect(page.site).to eq(site)
    end

    it 'sets the slug to be "the-money-advice-service"' do
      expect(page.slug).to eq('the-money-advice-service')
    end

    it "generates blank 'blocks' for each of the layout's content areas" do
      expect(page.blocks.count).to eq(3)
    end

    it 'publishes the home_page' do
      expect(page).to be_published
    end
  end
end
