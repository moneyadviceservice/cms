RSpec.describe Cms::PageBuilder do
  let!(:english_site)     { create(:site, is_mirrored: true) }
  let!(:welsh_site)       { create(:site, :welsh, is_mirrored: true) }
  let!(:article_layout)   { create(:layout, identifier: 'article', site: english_site) }
  let!(:home_page_layout) { create(:layout, identifier: 'home_page', site: english_site) }
  let!(:footer_layout)    { create(:layout, identifier: 'footer', site: english_site) }

  describe '.add_example_article!' do
    before { Cms::PageBuilder.add_example_article! }

    it 'adds a page' do
      expect(english_site.pages.count).to eq(1)
    end

    it 'adds a page using the "article" layout' do
      expect(Comfy::Cms::Page.first.layout).to eq(article_layout)
    end
  end

  describe '.add_home_page!' do
    before { Cms::PageBuilder.add_home_page! }

    let(:page) { english_site.pages.reload.first }

    it 'adds a page' do
      expect(english_site.pages.count).to eq(1)
    end

    it 'adds a page using the "home_page" layout' do
      expect(page.layout).to eq(home_page_layout)
    end

    it 'adds the page to the english site' do
      expect(page.site).to eq(english_site)
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

  describe '.add_footer!' do
    before { Cms::PageBuilder.add_footer! }

    context 'English site' do
      let(:page) { english_site.pages.reload.first }

      it 'adds a page' do
        expect(english_site.pages.count).to eq(1)
      end

      it 'adds a page using the "footer" layout' do
        expect(page.layout).to eq(footer_layout)
      end

      it 'adds the page to the english site' do
        expect(page.site).to eq(english_site)
      end

      it 'sets the slug to be "footer"' do
        expect(page.slug).to eq('footer')
      end

      it "generates blank 'blocks' for each of the layout's content areas" do
        expect(page.blocks.count).to eq(3)
      end

      it 'publishes the home_page' do
        expect(page).to be_published
      end
    end

    context 'Welsh site' do
      let(:page) { welsh_site.pages.reload.first }

      it 'adds a page' do
        expect(welsh_site.pages.count).to eq(1)
      end

      it 'adds a page using the "footer" layout' do
        expect(page.layout.identifier).to eq('footer')
      end

      it 'adds the page to the welsh site' do
        expect(page.site).to eq(welsh_site)
      end

      it 'sets the slug to be "footer"' do
        expect(page.slug).to eq('footer')
      end

      it "generates blank 'blocks' for each of the layout's content areas" do
        expect(page.blocks.count).to eq(3)
      end

      it 'publishes the home_page' do
        expect(page).to be_published
      end
    end
  end
end
