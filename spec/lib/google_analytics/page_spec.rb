module GoogleAnalytics
  RSpec.describe Page do
    describe 'popular_articles' do
      let(:profile) { double('profile') }

      let(:google_results) do
        [
          OpenStruct.new(pagePath: '/en/articles/help-with-debt', pageviews: '270'),
          OpenStruct.new(pagePath: '/en/articles/how-to-save-money', pageviews: '180'),
          OpenStruct.new(pagePath: '/en/articles/a-new-advice-article/preview', pageviews: '80'),
          OpenStruct.new(pagePath:  "/en/articles/{\"title\":\"Win Money\",\"desc\":\"Online casinoPlay now\"}&cost=0",
                         pageviews: '80'),
          OpenStruct.new(pagePath: '/en/news/ignore-news', pageviews: '70'),
          OpenStruct.new(pagePath: '/en/tools/ignore-tools', pageviews: '60'),
          OpenStruct.new(pagePath: '/cy/articles/ignore-welsh-article', pageviews: '50'),
          OpenStruct.new(pagePath:  'http://google.com/http://moneyadviceservice.org.uk/en/articles/ignore-embedded-english-article',
                         pageviews: '40')
        ]
      end

      before(:each) do
        allow(GoogleAnalytics::Page).to receive(:results).and_return(google_results)
      end

      subject { Page.popular_articles(profile) }

      it { expect(subject).to contain_article_label('help-with-debt', 270) }
      it { expect(subject).to contain_article_label('how-to-save-money', 180) }
      it { expect(subject).to contain_article_label('a-new-advice-article', 80) }
      it { expect(subject).to_not contain_article_label('ignore-news') }
      it { expect(subject).to_not contain_article_label('ignore-tools') }
      it { expect(subject).to_not contain_article_label('ignore-welsh-article') }
      it { expect(subject).to_not contain_article_label('ignore-embedded-english-article') }

      it 'handles strange JSON url' do
        # From real analytics
        expect(subject).to_not contain_article_label('{"title":"Win Money","desc":"Online casinoPlay now"}&cost=0')
      end
    end
  end
end
