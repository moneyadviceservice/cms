describe PageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site) }
  subject { described_class.new(article) }

  before do
    allow(article).to receive(:previous_article).and_return(nil)
    allow(article).to receive(:next_article).and_return(nil)
  end

  describe '#related_content' do

    context 'popular_links' do

      it 'has the three most popular articles' do

        site.label = 'en'
        pages =  [Comfy::Cms::Page.new(slug: 'first-article', label: 'First Article'),
                  Comfy::Cms::Page.new(slug: 'second-article', label: 'Second Article')]

        allow(Comfy::Cms::Page)
          .to receive(:most_popular)
          .with(3)
          .and_return(pages)

        popular_links = subject.related_content[:popular_links]
        expect(popular_links).to eq([
          { title: 'First Article', path: '/en/articles/first-article' },
          { title: 'Second Article', path: '/en/articles/second-article' }
        ])
      end

      it 'has the three most popular articles in welsh' do
        site.label = 'cy'
        english_article = Comfy::Cms::Page.new(slug: 'first-article-in_english', label: 'First Article in English')
        welsh_article = Comfy::Cms::Page.new(slug: 'first-article-in-welsh', label: 'First Article in Welsh')

        allow(english_article).to receive(:mirrors).and_return([welsh_article])

        allow(Comfy::Cms::Page)
          .to receive(:most_popular)
          .with(3)
          .and_return([english_article])

        popular_links = subject.related_content[:popular_links]
        expect(popular_links).to eq([
          { title: 'First Article in Welsh', path: '/cy/articles/first-article-in-welsh' }
        ])
      end

    end

    context 'has a previous link' do

      it 'has the title and path from the previous article' do
        previous_article = Comfy::Cms::Page.new(site: site, label: 'Previous Article', slug: 'previous-article')
        allow(article).to receive(:previous_page).and_return(previous_article)

        actual_previous_link = subject.related_content[:previous_link]

        expect(actual_previous_link[:title]).to eq('Previous Article')
        expect(actual_previous_link[:path]).to eq('/en/articles/previous-article')
      end

      it 'is empty if no previous article' do
        Comfy::Cms::Page.new(site: site, label: 'Previous Article', slug: 'previous-article')
        allow(article).to receive(:previous_page).and_return(nil)

        expect(subject.related_content[:previous_link]).to be_empty
      end

    end

    context 'has a next link' do

      it 'has the title and path from the next article' do
        next_article = Comfy::Cms::Page.new(site: site, label: 'Next Article', slug: 'next-article')
        allow(article).to receive(:next_page).and_return(next_article)

        actual_next_link = subject.related_content[:next_link]

        expect(actual_next_link[:title]).to eq('Next Article')
        expect(actual_next_link[:path]).to eq('/en/articles/next-article')
      end

      it 'is empty if no next article' do
        Comfy::Cms::Page.new(site: site, label: 'Next Article', slug: 'next-article')
        allow(article).to receive(:next_page).and_return(nil)

        expect(subject.related_content[:next_link]).to be_empty
      end

    end

  end

end
