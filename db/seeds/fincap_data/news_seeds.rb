english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

news_layout = english_site.layouts.find_or_create_by(
  identifier: 'news',
  label: 'News',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:field:order_by_date:datetime }}
    {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
)

latest_news_layout = english_site.layouts.find_or_create_by(
  identifier: 'latest_news',
  label: 'Latest News',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
)

english_site.pages.create!(
  label: 'Latest News',
  slug: 'news',
  layout: latest_news_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Here you will find all the latest news and press releases relating to the Financial Capability Strategy for the UK.

Our research enables us to give people the best advice on understanding financial matters and making choices when managing money. Visit our corporate site for all our latest [Research Reports](https://www.moneyadviceservice.org.uk/en/corporate/research).

Or, for a wide range of evaluation evidence, insight and market research don't forget to visit the new and improved Financial Capability [Evidence Hub](http://www.fincap.org.uk/evidence_hub).
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'Research suggests that young adults typically display lower levels of financial capability than older age groups.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_cta_links',
      content: <<-CONTENT
      [All news](/en/news)[2018](/en/news?year=2018)[2017](/en/news?year=2017)[2016](/en/news?year=2016)[2015](/en/news?year=2015)[2014](/en/news?year=2014)
      CONTENT
    )
  ]
)

news_page = english_site.pages.create!(
  label: 'Press Release: A new way to pay!',
  slug: 'press-release-a-new-way-to-pay',
  layout: news_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
The way in which payments are made in the UK is set to undergo the most radical
change since the 1960s. This follows the [launch of a new strategy](https://www.paymentsforum.uk/final-strategy) to give people
greater control over how they manage their day-to-day finances and help stamp
out financial fraud.
In the first industry-wide initiative of its kind, the Payments Strategy Forum,
whose members include consumer groups, businesses, fintechs, UK banks and
building societies, today recommends a new way of making payments that promises
greater protection and security for consumers and businesses.(2)
The Strategy gives:
*   More control and assurance for consumers over how they manage their finances
*   Safer and more secure banking
*   Opportunities for new banks and Fintechs to compete and offer innovative services that meet the needs of tomorrow’s users
Notes to editors
1.  Source: The Payment Systems Regulator
2.  The Payments Strategy Forum (the Forum) was announced by the Payment Systems Regulator (PSR) in its
Policy Statement published in March 2015.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'New strategy launched to make UK payments fit for the 21st Century'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_cta_links',
      content: <<-CONTENT
        [Latest News](/news)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'order_by_date',
      content: DateTime.new(2018, 7, 26)
    )
  ]
)

(1..10).each do |number|
  year = 2018
  month = 12 - number
  day = 20 - number

  news = english_site.pages.find_or_initialize_by(
    label: "News #{number}",
    slug: "news-#{number}",
    layout: news_layout,
    state: 'published'
  )
  news.blocks = [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
        A great news!
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'New strategy launched to make UK payments fit for the 21st Century'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_cta_links',
      content: <<-CONTENT
        [Latest News](/news)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'order_by_date',
      content: DateTime.new(year, month, day)
    )
  ]
  news.save!
end

news = english_site.pages.find_or_initialize_by(
  label: 'Scottish Financial Education Week',
  slug: 'scottish-financial-education-week',
  layout: news_layout,
  state: 'published'
)
news.blocks = [
  Comfy::Cms::Block.new(
    identifier: 'content',
    content: <<-CONTENT
      A great news!
    CONTENT
  ),
  Comfy::Cms::Block.new(
    identifier: 'component_hero_image',
    content: '/assets/styleguide/hero-sample.jpg'
  ),
  Comfy::Cms::Block.new(
    identifier: 'component_hero_description',
    content: 'New strategy launched to make UK payments fit for the 21st Century'
  ),
  Comfy::Cms::Block.new(
    identifier: 'component_cta_links',
    content: <<-CONTENT
      [Latest News](/news)
    CONTENT
  ),
  Comfy::Cms::Block.new(
    identifier: 'order_by_date',
    content: DateTime.new(2017, 3, 15)
  )
]
news.save!

mobile_payments_tag = Tag.find_or_create_by(value: 'mobile-payments')
secure_payments_tag = Tag.find_or_create_by(value: 'secure-payments')

[mobile_payments_tag, secure_payments_tag].each do |tag|
  news_page.keywords << tag
end

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
