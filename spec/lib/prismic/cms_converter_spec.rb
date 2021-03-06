RSpec.describe Prismic::CmsConverter do
  subject(:cms_converter) { described_class.new(document) }
  let(:document) { Prismic::Document.new(row) }

  describe '#convert' do
    subject(:convert) { cms_converter.convert }

    context 'when attributes do not have content' do
      let(:row) do
        {
          type: 'article',
          lang: 'en-GB'
        }
      end

      it 'returns documents with same attributes' do
        expect(convert).to eq(
          Prismic::ConvertedDocument.new(row)
        )
      end
    end

    context 'when attributes do not have any types mapped by prismic' do
      let(:row) do
        {
          content: [
            { some_field: 'foo', link: { title: 'foo', media: 'link' } }
          ]
        }
      end

      it 'ignores attributes' do
        expect(convert).to eq(
          Prismic::ConvertedDocument.new(
            content: [
              { some_field: 'foo', link: { title: 'foo', media: 'link' } }
            ]
          )
        )
      end
    end

    context 'when attributes have content' do
      context 'when attributes have tags following other tags' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => "Wednesday 11 January 2017\n\nWith rising inflation likely to lead to pay squeezes, firms need to do more to help their employees cope with financial concerns",
                  'spans' => [
                    {
                      'start' => 0, 'end' => 27, 'type' => 'strong'
                    },
                    {
                      'start' => 27, 'end' => 155, 'type' => 'em'
                    }
                  ]
                }
              }
            ]
          }
        end

        it 'converts both tags' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<p><strong>Wednesday 11 January 2017\n\n</strong><em>With rising inflation likely to lead to pay squeezes, firms need to do more to help their employees cope with financial concerns</em></p>",
              content_markdown: " **Wednesday 11 January 2017** _With rising inflation likely to lead to pay squeezes, firms need to do more to help their employees cope with financial concerns_\n\n"
            )
          )
        end
      end

      context 'when attributes have embedded videos' do
        let(:row) do
          {
            content: [
              {
                'content' => { 'spans' => [], 'text' => '' },
                'type' => 'embed',
                'data' =>                  {
                  'height' => 344,
                  'width' => 459,
                  'embed_url' => 'https://www.youtube.com/watch?v=ThmnAhEJ1Lk',
                  'type' => 'video',
                  'version' => '1.0',
                  'title' => 'What Works Funding - Webinar',
                  'author_name' => 'MoneyAdviceService',
                  'author_url' => 'https://www.youtube.com/user/MoneyAdviceService',
                  'provider_name' => 'YouTube',
                  'provider_url' => 'https://www.youtube.com/',
                  'cache_age' => nil,
                  'thumbnail_url' => 'https://i.ytimg.com/vi/ThmnAhEJ1Lk/hqdefault.jpg',
                  'thumbnail_width' => 480,
                  'thumbnail_height' => 360,
                  'html' => "<iframe width=\'459\" height=\"344\" src=\"https://www.youtube.com/embed/ThmnAhEJ1Lk?feature=oembed\" frameborder=\"0\" allowfullscreen></iframe>"
                },
                'label' => nil,
                'direction' => nil
              }
            ]
          }
        end

        it 'converts to html tags' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<iframe width=\'459\" height=\"344\" src=\"https://www.youtube.com/embed/ThmnAhEJ1Lk?feature=oembed\" frameborder=\"0\" allowfullscreen></iframe>",
              content_markdown: "<iframe width='459\" height=\"344\" src=\"https://www.youtube.com/embed/ThmnAhEJ1Lk?feature=oembed\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;'></iframe>"
            )
          )
        end
      end

      context 'when attributes have images' do
        let(:row) do
          {
            content: [
              {
                'content' => { 'spans' => [], 'text' => '' },
                'type' => 'image',
                'data' => {
                  'origin' => {
                    'id' => 'V0W9PyUAAKwMBoZk',
                    'url' => 'https://prismic-io.s3.amazonaws.com/fincap-two%2F192ce333-1802-45e3-9a45-57c792c21e50_the+pensions+dashboard.png',
                    'width' => 2624,
                    'height' => 2624
                  },
                  'width' => 2624,
                  'height' => 2624,
                  'url' => 'https://fincap-two.cdn.prismic.io/fincap-two/981f9fff7abfca68edf52ba7915e1d90cb70dc27_the-pensions-dashboard.png',
                  'edit' => {
                    'background' => 'transparent',
                    'zoom' => 1.0,
                    'crop' => { 'x' => 0, 'y' => 0 }
                  },
                  'credits' => nil,
                  'alt' => nil,
                  'linkTo' => nil
                },
                'label' => nil,
                'direction' => nil
              }
            ]
          }
        end

        it 'converts to image html tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<img src="https://fincap-two.cdn.prismic.io/fincap-two/981f9fff7abfca68edf52ba7915e1d90cb70dc27_the-pensions-dashboard.png" width="2624" height="2624" />',
              content_markdown: ' ![](https://fincap-two.cdn.prismic.io/fincap-two/981f9fff7abfca68edf52ba7915e1d90cb70dc27_the-pensions-dashboard.png)'
            )
          )
        end
      end

      context 'when attributes have external links' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => "•\tTo view the Money Advice Service Financial Capability UK Survey report, please click here",
                  'spans' => [
                    { 'start' => 0, 'end' => 87, 'type' => 'strong' },
                    { 'start' => 87,
                      'end' => 91,
                      'type' => 'hyperlink',
                      'data' => {
                        'wioUrl' => 'wio://medias/WFEJPioAAL4bnH2x',
                        'url' => 'https://prismic-io.s3.amazonaws.com/fincap-two%2Fd08746d1-e667-4c9e-84ad-8539ce5c62e0_mas_fincap_uk_survey_2015_aw.pdf',
                        'kind' => 'document',
                        'id' => 'WFEJPioAAL4bnH2x',
                        'size' => '2902326',
                        'date' => '12/14/16 08:53',
                        'name' => 'MAS_FinCap_UK_Survey_2015_AW.PDF',
                        'preview' => {
                          'title' => 'MAS_FinCap_UK_Survey_2015_AW.PDF',
                          'image' => nil
                        }
                      } },
                    { 'start' => 87, 'end' => 91, 'type' => 'strong' }
                  ]
                }
              }
            ]
          }
        end

        it 'converts the links' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<p><strong>•\tTo view the Money Advice Service Financial Capability UK Survey report, please click </strong><a href=\"https://prismic-io.s3.amazonaws.com/fincap-two%2Fd08746d1-e667-4c9e-84ad-8539ce5c62e0_mas_fincap_uk_survey_2015_aw.pdf\"><strong>here</strong></a></p>",
              content_markdown: " **• To view the Money Advice Service Financial Capability UK Survey report, please click** [**here**](https://prismic-io.s3.amazonaws.com/fincap-two%2Fd08746d1-e667-4c9e-84ad-8539ce5c62e0_mas_fincap_uk_survey_2015_aw.pdf)\n\n"
            )
          )
        end
      end

      context 'when attributes have emphasis text' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Caroline Rookes, Chief Executive of the Money Advice Service, said: “Pension provision has changed significantly over recent years and it is more important than ever that individuals make good decisions so their money lasts for the full length of their retirement. We know that online banking has empowered people to engage with their money more regularly. We hope that being able to keep track of their pension savings in a single digital place will ensure that people are fully informed and can make decisions about their future savings in a similar way. ',
                  'spans' => [
                    {
                      'start' => 0,
                      'end' => 67,
                      'type' => 'strong'
                    },
                    {
                      'start' => 68,
                      'end' => 557,
                      'type' => 'em'
                    }
                  ]
                }
              }
            ]
          }
        end

        it 'converts to emphasied html tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p><strong>Caroline Rookes, Chief Executive of the Money Advice Service, said:</strong> <em>“Pension provision has changed significantly over recent years and it is more important than ever that individuals make good decisions so their money lasts for the full length of their retirement. We know that online banking has empowered people to engage with their money more regularly. We hope that being able to keep track of their pension savings in a single digital place will ensure that people are fully informed and can make decisions about their future savings in a similar way. </em></p>',
              content_markdown: " **Caroline Rookes, Chief Executive of the Money Advice Service, said:** _“Pension provision has changed significantly over recent years and it is more important than ever that individuals make good decisions so their money lasts for the full length of their retirement. We know that online banking has empowered people to engage with their money more regularly. We hope that being able to keep track of their pension savings in a single digital place will ensure that people are fully informed and can make decisions about their future savings in a similar way. _\n\n"
            )
          )
        end
      end

      context 'when attributes have ordered lists' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'The Strategy is built around two key concepts:',
                  'spans' => [{ 'start' => 0, 'end' => 46, 'type' => 'strong' }]
                }
              },
              {
                'type' => 'o-list-item',
                'content' => {
                  'text' => 'Collective impact and cross-sector co-ordination rather than isolated interventions.',
                  'spans' => []
                }
              },
              {
                'type' => 'o-list-item',
                'content' => {
                  'text' => 'Testing and learning to determine what works in order to deliver evidence-based interventions: resources will be steered towards activities on the basis of what is proven to work.',
                  'spans' => []
                }
              },
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Overall progress will be monitored by a Financial Capability Survey and ongoing evaluation of specific interventions.',
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'wrap text with ordered list tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p><strong>The Strategy is built around two key concepts:</strong></p><ol><li>Collective impact and cross-sector co-ordination rather than isolated interventions.</li><li>Testing and learning to determine what works in order to deliver evidence-based interventions: resources will be steered towards activities on the basis of what is proven to work.</li></ol><p>Overall progress will be monitored by a Financial Capability Survey and ongoing evaluation of specific interventions.</p>',
              content_markdown: " **The Strategy is built around two key concepts:**\n\n1. Collective impact and cross-sector co-ordination rather than isolated interventions.\n2. Testing and learning to determine what works in order to deliver evidence-based interventions: resources will be steered towards activities on the basis of what is proven to work.\n\nOverall progress will be monitored by a Financial Capability Survey and ongoing evaluation of specific interventions.\n\n"
            )
          )
        end
      end

      context 'when attributes have lists' do
        let(:row) do
          {
            content: [
              {
                'type' => 'list-item',
                'content' => {
                  'text' => "Relate to people's financial capability",
                  'spans' => []
                }
              },
              {
                'type' => 'list-item',
                'content' =>                       {
                  'text' => 'Make a positive contribution to evidence hub, given what is on there already',
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'wrap text with unordered list tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<ul><li>Relate to people's financial capability</li><li>Make a positive contribution to evidence hub, given what is on there already</li></ul>",
              content_markdown: "- Relate to people's financial capability\n- Make a positive contribution to evidence hub, given what is on there already\n"
            )
          )
        end
      end

      context 'when attributes have list with bold' do
        let(:row) do
          {
            content: [
              {
                'type' => 'list-item',
                'content' => {
                  'text' => 'Programme theory describes how a programme is intended to work and provides some rationale for the design with reference to existing evidence. It describes the intended sequence from activities through to longer term outcomes, acknowledging any important assumptions along the way. This could include a logic model or theory of change diagram;',
                  'spans' => [{ 'start' => 0, 'end' => 16, 'type' => 'strong' }]
                }
              },
              {
                'type' => 'list-item',
                'content' => {
                  'text' => 'Measured outcomes reports evidence of changes that occurred over the course of a programme with reference to the programme’s intended effects. It demonstrates efforts to minimize biasand to accurately represent the experiences of programme participants;',
                  'spans' => [{ 'start' => 0, 'end' => 17, 'type' => 'strong' }]
                }
              }
            ]
          }
        end

        it 'wrap text with unordered list tag with bold' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<ul><li><strong>Programme theory</strong> describes how a programme is intended to work and provides some rationale for the design with reference to existing evidence. It describes the intended sequence from activities through to longer term outcomes, acknowledging any important assumptions along the way. This could include a logic model or theory of change diagram;</li><li><strong>Measured outcomes</strong> reports evidence of changes that occurred over the course of a programme with reference to the programme’s intended effects. It demonstrates efforts to minimize biasand to accurately represent the experiences of programme participants;</li></ul>',
              content_markdown: "- **Programme theory** describes how a programme is intended to work and provides some rationale for the design with reference to existing evidence. It describes the intended sequence from activities through to longer term outcomes, acknowledging any important assumptions along the way. This could include a logic model or theory of change diagram;\n- **Measured outcomes** reports evidence of changes that occurred over the course of a programme with reference to the programme’s intended effects. It demonstrates efforts to minimize biasand to accurately represent the experiences of programme participants;\n"
            )
          )
        end
      end

      context 'when attributes has bold and emphasis on the same index' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => '12 million people in the UK are not saving enough for their retirement (DWP, 2014). ',
                  'spans' => [
                    { 'start' => 0, 'end' => 71, 'type' => 'label', 'data' => 'very-emphatic' },
                    { 'start' => 71, 'end' => 84, 'type' => 'strong' },
                    { 'start' => 71, 'end' => 84, 'type' => 'em' }
                  ]
                }
              }
            ]
          }
        end

        it 'converts to strong and emphasis' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p>12 million people in the UK are not saving enough for their retirement <strong><em>(DWP, 2014). </em></strong></p>',
              content_markdown: "12 million people in the UK are not saving enough for their retirement **_(DWP, 2014). _**\n\n"
            )
          )
        end
      end

      context 'when attribute has paragraphs and lists' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Four out of 10 adults are not in control of their finances – new strategy launched to improve UK’s financial capability',
                  'spans' => []
                }
              },
              {
                'type' => 'list-item',
                'content' => {
                  'text' => 'Around four out of ten adults are not in control of their finances',
                  'spans' => []
                }
              },
              {
                'type' => 'list-item',
                'content' => {
                  'text' => 'One in five cannot read a bank statement', 'spans' => []
                }
              },
              {
                'type' => 'paragraph',
                'content' => {
                  'text' =>                          'Leading figures from across the financial services industry, government, third sector organisations and charities have come together to launch a major initiative to address the stubbornly low levels of financial capability in the UK.',
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'convert paragraphs and unordered lists' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p>Four out of 10 adults are not in control of their finances – new strategy launched to improve UK’s financial capability</p><ul><li>Around four out of ten adults are not in control of their finances</li><li>One in five cannot read a bank statement</li></ul><p>Leading figures from across the financial services industry, government, third sector organisations and charities have come together to launch a major initiative to address the stubbornly low levels of financial capability in the UK.</p>',
              content_markdown: "Four out of 10 adults are not in control of their finances – new strategy launched to improve UK’s financial capability\n\n- Around four out of ten adults are not in control of their finances\n- One in five cannot read a bank statement\n\nLeading figures from across the financial services industry, government, third sector organisations and charities have come together to launch a major initiative to address the stubbornly low levels of financial capability in the UK.\n\n"
            )
          )
        end
      end

      context 'when attribute does not contain special format' do
        let(:row) do
          {
            content: [{
              'type' => 'paragraph',
              'content' => {
                'text' => 'Audio clip available for use on radio.',
                'spans' => []
              }
            }]
          }
        end

        it 'wrap text with paragraph html tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p>Audio clip available for use on radio.</p>',
              content_markdown: "Audio clip available for use on radio.\n\n"
            )
          )
        end
      end

      context 'when attribute contains bold text' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Monday 25th September 2016',
                  'spans' => [{ 'start' => 0, 'end' => 26, 'type' => 'strong' }]
                }
              }
            ]
          }
        end

        it 'wraps text with paragraph tag and format with bold text' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p><strong>Monday 25th September 2016</strong></p>',
              content_markdown: " **Monday 25th September 2016**\n\n"
            )
          )
        end
      end

      context 'when content has multiple paragraphs' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Audio clip available for use on radio.',
                  'spans' => []
                }
              },
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'The need to improve financial education.',
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'wraps text with paragraph html tags' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: '<p>Audio clip available for use on radio.</p><p>The need to improve financial education.</p>',
              content_markdown: "Audio clip available for use on radio.\n\nThe need to improve financial education.\n\n"
            )
          )
        end
      end

      context 'when attributes have multiple bold text' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => "* Fair Funerals looked at 100 independent companies and 100 branches of Co-op Funeralcare and Dignity Funerals (the two largest UK funeral providers) in mystery shopping which checked for affordability and transparency. At the time of conducting the mystery shopping, neither Dignity not Co-op Funeralcare had online prices for any of their branches. \n\nEnds \\\\\n\nNotes to editors\nFor more information and to arrange interviews with case studies and the Fair Funerals team, please call 020 8983 5059 or email heatherkennedy@qsa.org.uk \n\nAbout Quaker Social Action\nQuaker Social Action exists to resource, enable and equip people living on a low income in east London. Our projects work towards our vision of 'a just world where people put people first', recognising the people we work with as agents of change not objects of charity. We work to tackle social exclusion, seeing poverty as not just material but also social. Our work is practical, relating to the everyday needs of the people we work with to make a tangible difference to their lives.\n\nAbout the Fair Funerals campaign\nQuaker Social Action launched the Fair Funerals campaign in 2014 to tackle the underlying causes of funeral poverty. It does this by:\n•\tEducating people about their choices so they can avoid funeral poverty\n•\tInfluencing government to do more for people in funeral poverty\n•\tWorking with the funeral industry to do moror people in funeral poverty\nVisit us here: http://fairfuneralscampaign.org.uk/",
                  'spans' => [
                    { 'start' => 353, 'end' => 360, 'type' => 'strong' },
                    { 'start' => 361, 'end' => 378, 'type' => 'strong' },
                    { 'start' => 535, 'end' => 561, 'type' => 'strong' },
                    { 'start' => 1048, 'end' => 1081, 'type' => 'strong' }
                  ]
                }
              }
            ]
          }
        end

        it 'converts to strong tags' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<p>* Fair Funerals looked at 100 independent companies and 100 branches of Co-op Funeralcare and Dignity Funerals (the two largest UK funeral providers) in mystery shopping which checked for affordability and transparency. At the time of conducting the mystery shopping, neither Dignity not Co-op Funeralcare had online prices for any of their branches. \n\n<strong>Ends \\\\</strong>\n<strong>\nNotes to editors</strong>\nFor more information and to arrange interviews with case studies and the Fair Funerals team, please call 020 8983 5059 or email heatherkennedy@qsa.org.uk \n\n<strong>About Quaker Social Action</strong>\nQuaker Social Action exists to resource, enable and equip people living on a low income in east London. Our projects work towards our vision of 'a just world where people put people first', recognising the people we work with as agents of change not objects of charity. We work to tackle social exclusion, seeing poverty as not just material but also social. Our work is practical, relating to the everyday needs of the people we work with to make a tangible difference to their lives.\n<strong>\nAbout the Fair Funerals campaign</strong>\nQuaker Social Action launched the Fair Funerals campaign in 2014 to tackle the underlying causes of funeral poverty. It does this by:\n•\tEducating people about their choices so they can avoid funeral poverty\n•\tInfluencing government to do more for people in funeral poverty\n•\tWorking with the funeral industry to do moror people in funeral poverty\nVisit us here: http://fairfuneralscampaign.org.uk/</p>",
              content_markdown: "\\* Fair Funerals looked at 100 independent companies and 100 branches of Co-op Funeralcare and Dignity Funerals (the two largest UK funeral providers) in mystery shopping which checked for affordability and transparency. At the time of conducting the mystery shopping, neither Dignity not Co-op Funeralcare had online prices for any of their branches. **Ends \\\\**** Notes to editors **For more information and to arrange interviews with case studies and the Fair Funerals team, please call 020 8983 5059 or email heatherkennedy@qsa.org.uk** About Quaker Social Action **Quaker Social Action exists to resource, enable and equip people living on a low income in east London. Our projects work towards our vision of 'a just world where people put people first', recognising the people we work with as agents of change not objects of charity. We work to tackle social exclusion, seeing poverty as not just material but also social. Our work is practical, relating to the everyday needs of the people we work with to make a tangible difference to their lives.** About the Fair Funerals campaign**Quaker Social Action launched the Fair Funerals campaign in 2014 to tackle the underlying causes of funeral poverty. It does this by: • Educating people about their choices so they can avoid funeral poverty • Influencing government to do more for people in funeral poverty • Working with the funeral industry to do moror people in funeral poverty Visit us here: http://fairfuneralscampaign.org.uk/\n\n"
            )
          )
        end
      end

      context 'when attribute has heading one' do
        let(:row) do
          {
            title: [
              {
                'type' => 'heading1',
                'content' => {
                  'text'  => "The Money Charity's Financial Education Report",
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'wraps text with heading one html tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              title: "<h1>The Money Charity's Financial Education Report</h1>",
              title_markdown: "# The Money Charity's Financial Education Report\n"
            )
          )
        end
      end

      context 'when attribute has a lot of content' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => "Photographs from the West Lothian Credit Union visit are available to download at: https://www.flickr.com/photos/scottishgovernment/ \n\nThe projects receiving funding are:\nEast Renfrewshire Credit Union\t\nEast Renfrewshire\t\n£20,000\n\nBlackburn, Seafield and District Credit Union\t\nWest Lothian\t\n£20,000\n\nSovereign Credit Union\t\nAyrshire, Arran, Dumfries & Galloway\t\n£20,000\n\nStirling Credit Union\t\nStirling\t\n£20,000\n\nWest Lothian Credit Union\t\nWest Lothian\t\n£20,000\n\nFalkirk District Credit Union\t\nFalkirk\t\n£20,000\n\nYoker Credit Union\t\nGlasgow\t\n£20,000\n\nSolway Credit Union\t\nDumfries and Galloway\t\n£12,000\n\nNorth East Credit Union\t\nAberdeen\t\n£20,000\n\nBCD Credit Union\t\nGlasgow\t\n£20,000\n\nTotal \t \t£192,000 ",
                  'spans' => [{ 'start' => 684, 'end' => 702, 'type' => 'strong' }]
                }
              }
            ]
          }
        end

        it 'transforms into html' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              content: "<p>Photographs from the West Lothian Credit Union visit are available to download at: https://www.flickr.com/photos/scottishgovernment/ \n\nThe projects receiving funding are:\nEast Renfrewshire Credit Union\t\nEast Renfrewshire\t\n£20,000\n\nBlackburn, Seafield and District Credit Union\t\nWest Lothian\t\n£20,000\n\nSovereign Credit Union\t\nAyrshire, Arran, Dumfries & Galloway\t\n£20,000\n\nStirling Credit Union\t\nStirling\t\n£20,000\n\nWest Lothian Credit Union\t\nWest Lothian\t\n£20,000\n\nFalkirk District Credit Union\t\nFalkirk\t\n£20,000\n\nYoker Credit Union\t\nGlasgow\t\n£20,000\n\nSolway Credit Union\t\nDumfries and Galloway\t\n£12,000\n\nNorth East Credit Union\t\nAberdeen\t\n£20,000\n\nBCD Credit Union\t\nGlasgow\t\n£20,000\n\n<strong>Total \t \t£192,000 </strong></p>",
              content_markdown: "Photographs from the West Lothian Credit Union visit are available to download at: https://www.flickr.com/photos/scottishgovernment/ The projects receiving funding are: East Renfrewshire Credit Union East Renfrewshire £20,000 Blackburn, Seafield and District Credit Union West Lothian £20,000 Sovereign Credit Union Ayrshire, Arran, Dumfries & Galloway £20,000 Stirling Credit Union Stirling £20,000 West Lothian Credit Union West Lothian £20,000 Falkirk District Credit Union Falkirk £20,000 Yoker Credit Union Glasgow £20,000 Solway Credit Union Dumfries and Galloway £12,000 North East Credit Union Aberdeen £20,000 BCD Credit Union Glasgow £20,000 **Total £192,000**\n\n"
            )
          )
        end
      end

      context 'when attribute has heading 5' do
        let(:row) do
          {
            title: [
              {
                'type' => 'heading5',
                'content' => {
                  'text'  => "The Money Charity's Financial Education Report",
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'wraps text with heading one html tag' do
          expect(convert).to eq(
            Prismic::ConvertedDocument.new(
              title: "<h5>The Money Charity's Financial Education Report</h5>",
              title_markdown: "##### The Money Charity's Financial Education Report\n"
            )
          )
        end
      end
    end
  end
end
