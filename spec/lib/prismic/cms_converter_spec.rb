RSpec.describe Prismic::CmsConverter do
  subject(:cms_converter) { described_class.new(document) }
  let(:document) { Prismic::Document.new(row) }

  describe '#convert' do
    subject(:convert) { cms_converter.convert }

    context 'when attributes does not have content' do
      let(:row) do
        {
          type: 'article',
          lang: 'en-GB'
        }
      end

      it 'returns documents with same attributes' do
        expect(convert).to eq(
          Prismic::CmsDocument.new(row)
        )
      end
    end

    context 'when attributes does not have any types mapped by prismic' do
      let(:row) do
        {
          content: [
            { some_field: 'foo', link: { title: 'foo', media: 'link' } }
          ]
        }
      end

      it 'ignores attributes' do
        expect(convert).to eq(
          Prismic::CmsDocument.new(content: '')
        )
      end
    end

    context 'when attributes have content' do
      context 'when attributes have emphasis text' do
        let(:row) do
          {
            content: [
              {
                "type"=>"paragraph",
                "content"=> {
                  "text"=> "Caroline Rookes, Chief Executive of the Money Advice Service, said: “Pension provision has changed significantly over recent years and it is more important than ever that individuals make good decisions so their money lasts for the full length of their retirement. We know that online banking has empowered people to engage with their money more regularly. We hope that being able to keep track of their pension savings in a single digital place will ensure that people are fully informed and can make decisions about their future savings in a similar way. ",
                  "spans"=> [
                    {
                      "start"=>0,
                      "end"=>67,
                      "type"=>"strong"
                    },
                    {
                      "start"=>68,
                      "end"=>557,
                      "type"=>"em"
                    }
                  ]
                }
              }
            ]
          }
        end

        it 'converts to emphasied html tag' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: '<p><strong>Caroline Rookes, Chief Executive of the Money Advice Service, said:</strong><em>“Pension provision has changed significantly over recent years and it is more important than ever that individuals make good decisions so their money lasts for the full length of their retirement. We know that online banking has empowered people to engage with their money more regularly. We hope that being able to keep track of their pension savings in a single digital place will ensure that people are fully informed and can make decisions about their future savings in a similar way. </em></p>'
            )
          )
        end
      end

      context 'when attributes have ordered lists' do
        let(:row) do
          {
            content: [
 							{
              	'type'=>'paragraph',
                'content'=>{
                  'text'=>'The Strategy is built around two key concepts:',
                  'spans'=>[{'start'=>0, 'end'=>46, 'type'=>'strong'}]
                }
              },
 							{
                'type'=>'o-list-item',
                'content'=> {
                  'text'=>'Collective impact and cross-sector co-ordination rather than isolated interventions.',
                  'spans'=>[]
                }
              },
 							{
                'type'=>'o-list-item',
 							  'content'=> {
                  'text'=> 'Testing and learning to determine what works in order to deliver evidence-based interventions: resources will be steered towards activities on the basis of what is proven to work.',
 							   'spans'=>[]
                }
              },
 							{
                'type'=>'paragraph',
 							 'content'=> {
                  'text'=>'Overall progress will be monitored by a Financial Capability Survey and ongoing evaluation of specific interventions.',
                  'spans'=>[]
                }
              }
            ]
          }
        end

        it 'wrap text with ordered list tag' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: '<p><strong>The Strategy is built around two key concepts:</strong></p><ol><li>Collective impact and cross-sector co-ordination rather than isolated interventions.</li><li>Testing and learning to determine what works in order to deliver evidence-based interventions: resources will be steered towards activities on the basis of what is proven to work.</li></ol><p>Overall progress will be monitored by a Financial Capability Survey and ongoing evaluation of specific interventions.</p>'
            )
          )
        end
      end

      context 'when attributes have lists' do
        let(:row) do
          {
            content: [
						  {
					    	'type'=>'list-item',
					    	'content'=> {
									'text' => "Relate to people's financial capability",
									'spans'=>[]
								}
							},
					    {
								'type'=>'list-item',
					     	'content'=>
					      {
									'text' => 'Make a positive contribution to evidence hub, given what is on there already',
					      'spans' => []
								}
							},
            ]
          }
        end

        it 'wrap text with unordered list tag' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
							content: "<ul><li>Relate to people's financial capability</li><li>Make a positive contribution to evidence hub, given what is on there already</li></ul>"
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
					  	    'spans' => [{'start' => 0, 'end' => 16, 'type' => 'strong'}]
							  }
              },
					 		{
							  'type' => 'list-item',
					 		  'content' => {
                  'text' => "Measured outcomes reports evidence of changes that occurred over the course of a programme with reference to the programme’s intended effects. It demonstrates efforts to minimize biasand to accurately represent the experiences of programme participants;",
					 		   'spans' => [{'start'=>0, 'end'=>17, 'type'=>'strong'}]
                }
							}
            ]
          }
        end

        it 'wrap text with unordered list tag with bold' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: "<ul><li>\n<strong>Programme theory</strong> describes how a programme is intended to work and provides some rationale for the design with reference to existing evidence. It describes the intended sequence from activities through to longer term outcomes, acknowledging any important assumptions along the way. This could include a logic model or theory of change diagram;</li><li>\n<strong>Measured outcomes</strong> reports evidence of changes that occurred over the course of a programme with reference to the programme’s intended effects. It demonstrates efforts to minimize biasand to accurately represent the experiences of programme participants;</li></ul>"
            )
          )
        end
			end

      context 'when attribute has paragraphs and lists' do
        let(:row) do
          {
            content: [
							{
								'type'=>'paragraph',
							  'content'=>
							   {'text'=>
							     "Four out of 10 adults are not in control of their finances – new strategy launched to improve UK’s financial capability",
							    'spans'=>[]
			          	}
              },
							{
                'type'=>'list-item',
							  'content'=> {
                  'text'=>'Around four out of ten adults are not in control of their finances',
							    'spans'=>[]
                }
              },
							{
                'type'=>'list-item',
							  'content'=>{
                  'text'=>'One in five cannot read a bank statement', 'spans'=>[]
                }
              },
							{
                'type'=>'paragraph',
							  'content'=> {
                  'text'=>
							    'Leading figures from across the financial services industry, government, third sector organisations and charities have come together to launch a major initiative to address the stubbornly low levels of financial capability in the UK.',
                  'spans' => []
                }
              }
            ]
          }
        end

        it 'convert paragraphs and unordered lists' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: "<p>Four out of 10 adults are not in control of their finances – new strategy launched to improve UK’s financial capability</p><ul><li>Around four out of ten adults are not in control of their finances</li><li>One in five cannot read a bank statement</li></ul><p>Leading figures from across the financial services industry, government, third sector organisations and charities have come together to launch a major initiative to address the stubbornly low levels of financial capability in the UK.</p>"
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
            Prismic::CmsDocument.new(
              content: '<p>Audio clip available for use on radio.</p>'
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

        it 'wrap text with paragraph tag and format with bold text' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: '<p><strong>Monday 25th September 2016</strong></p>'
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

        it 'wrap text with paragraph html tags' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              content: '<p>Audio clip available for use on radio.</p><p>The need to improve financial education.</p>'
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

        it 'wrap text with heading one html tag' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              title: "<h1>The Money Charity's Financial Education Report</h1>"
            )
         )
        end
      end

      context 'when attribute has lot of content' do
        let(:row) do
          {
            content: [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => "Photographs from the West Lothian Credit Union visit are available to download at: https://www.flickr.com/photos/scottishgovernment/ \n\nThe projects receiving funding are:\nEast Renfrewshire Credit Union\t\nEast Renfrewshire\t\n£20,000\n\nBlackburn, Seafield and District Credit Union\t\nWest Lothian\t\n£20,000\n\nSovereign Credit Union\t\nAyrshire, Arran, Dumfries & Galloway\t\n£20,000\n\nStirling Credit Union\t\nStirling\t\n£20,000\n\nWest Lothian Credit Union\t\nWest Lothian\t\n£20,000\n\nFalkirk District Credit Union\t\nFalkirk\t\n£20,000\n\nYoker Credit Union\t\nGlasgow\t\n£20,000\n\nSolway Credit Union\t\nDumfries and Galloway\t\n£12,000\n\nNorth East Credit Union\t\nAberdeen\t\n£20,000\n\nBCD Credit Union\t\nGlasgow\t\n£20,000\n\nTotal \t \t£192,000 ",
                  'spans'=>[{'start'=>684, 'end'=>702, 'type'=>'strong'}]
                }
              }
            ]
          }
        end

        it 'transform into html' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(content: "<p>Photographs from the West Lothian Credit Union visit are available to download at: https://www.flickr.com/photos/scottishgovernment/ \n\nThe projects receiving funding are:\nEast Renfrewshire Credit Union\t\nEast Renfrewshire\t\n£20,000\n\nBlackburn, Seafield and District Credit Union\t\nWest Lothian\t\n£20,000\n\nSovereign Credit Union\t\nAyrshire, Arran, Dumfries &amp; Galloway\t\n£20,000\n\nStirling Credit Union\t\nStirling\t\n£20,000\n\nWest Lothian Credit Union\t\nWest Lothian\t\n£20,000\n\nFalkirk District Credit Union\t\nFalkirk\t\n£20,000\n\nYoker Credit Union\t\nGlasgow\t\n£20,000\n\nSolway Credit Union\t\nDumfries and Galloway\t\n£12,000\n\nNorth East Credit Union\t\nAberdeen\t\n£20,000\n\nBCD Credit Union\t\nGlasgow\t\n£20,000\n\n<strong>Total \t \t£192,000 </strong></p>")
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

        it 'wrap text with heading one html tag' do
          expect(convert).to eq(
            Prismic::CmsDocument.new(
              title: "<h5>The Money Charity's Financial Education Report</h5>"
            )
          )
        end
      end
    end
  end
end
