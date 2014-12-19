describe PageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site) }
  subject { described_class.new(article) }

  describe '#related_content' do

    context 'popular_links' do

      it 'has the three most popular articles' do
        site.label = 'en'
        pages = [ Comfy::Cms::Page.new(slug: 'first-article', label: 'First Article'),
                  Comfy::Cms::Page.new(slug: 'second-article', label: 'Second Article')
                ]

        allow(Comfy::Cms::Page).
          to receive(:most_popular).
          with(3).
          and_return(pages)

        popular_links = subject.related_content[:popular_links]
        expect(popular_links).to eq([
            {title: 'First Article', path: '/en/articles/first-article'},
            {title: 'Second Article', path: '/en/articles/second-article'}
        ])
      end

      it 'has the three most popular articles in welsh' do
        site.label = 'cy'
        english_article = Comfy::Cms::Page.new(slug: 'first-article-in_english', label: 'First Article in English')
        welsh_article = Comfy::Cms::Page.new(slug: 'first-article-in-welsh', label: 'First Article in Welsh')

        allow(english_article).to receive(:mirrors).and_return([welsh_article])

        allow(Comfy::Cms::Page).
          to receive(:most_popular).
          with(3).
          and_return([english_article])

        popular_links = subject.related_content[:popular_links]
        expect(popular_links).to eq([
          {title: 'First Article in Welsh', path: '/cy/articles/first-article-in-welsh'}
        ])
      end

    end

  end

end
