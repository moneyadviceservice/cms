describe PageSerializer do
  let(:article) { Comfy::Cms::Page.new }
  subject { described_class.new(article) }

  describe '#related_content' do

    context 'popular_links' do

      it 'has the three most popular articles' do
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

    end

  end

end