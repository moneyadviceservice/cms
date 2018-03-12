RSpec.describe DocumentProvider do
  subject { described_class.new(site, document_type, keyword, filters)}
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:document_type) { nil }
  let(:keyword) { nil }
  let(:filters) { nil }

  let(:insight_page_params) { {site: site, layout: insight_layout } }
  
  let(:review_layout)  { create :layout, identifier: 'review' }
  let(:insight_layout) { create :layout, identifier: 'insight' }

  let!(:insight_page1) { create(:insight_page_about_financial_wellbeing, insight_page_params) }
  let!(:insight_page2) { create(:insight_page_about_debt, insight_page_params) }
  let!(:insight_page3) { create(:insight_page_about_pensions, insight_page_params) }
  let!(:insight_page4) { create(:insight_page_titled_annuity, insight_page_params) }
  let!(:insight_page5) { create(:insight_page_titled_annuity2, insight_page_params) }
  let!(:insight_page6) { create(:insight_page_about_annuity, insight_page_params) }
  let!(:insight_page7) { create(:insight_page_with_lotsa_blocks, insight_page_params) }
  let!(:insight_page8) { create(:insight_page_with_raw_cta_text_block, insight_page_params) }
  let!(:review_page1) { create(:page, site: site, layout: review_layout) }

  describe '#retrieve' do
    let(:documents) { subject.retrieve }

    context 'when all documents are requested' do
      it 'returns all documents' do
        expect(documents.size).to eq(9)
      end
    end

    context 'when documents of type insight are requested' do
      let(:document_type) { 'review' }

      it 'returns all insight documents' do
        expect(documents).to match_array([review_page1])
      end
    end
  end

  describe 'keyword search' do
    let(:documents) { subject.retrieve }

    context 'when the document_type is specified' do
      context 'when a keyword is provided' do
        context 'and the keyword is found in a "content" block' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'pension' }

          it 'returns documents which contain the keyword' do
            expect(documents.size).to eq(1)
            expect(keyword).to be_in(documents.first.blocks.first.content)
          end
        end

        context 'and the keyword is found in an "overview" block' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'redundancy' }

          it 'returns documents which contain the keyword' do
            expect(documents.size).to eq(1)
            expect(documents.first.label).to eq('Redundancy overview')
            expect(documents).to match_array([insight_page7])
          end
        end

        context 'and the keyword is found in a block that is not content or overview' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'random' }

          it 'does not return the document' do
            expect(documents.count).to eq(0)
          end
        end

        context 'and the keyword is found in the middle of the title' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'stress' }

          it 'returns documents with the keyword in the title' do
            expect(documents.count).to eq(1)
            expect(documents.first.label).to eq('Debt, stress and pay levels')
          end
        end

        context 'and the keyword is found at the start of the title' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'annuity' }

          it 'returns documents with the keyword at the start of the title' do
            expect(documents.first.label).to eq('annuity')
          end
        end

        context 'and the keyword is in the title of one document and content of another' do
          let(:document_type) { 'insight' }
          let(:keyword) { 'annuity' }

          it 'returns both documents' do
            expect(documents).to match_array([insight_page4, insight_page5, insight_page6])
          end
        end
      end

      context 'when the keyword is not found' do
        let(:document_type) { 'insight' }
        let(:keyword) { 'nosuchterm' }

        it 'returns an empty array' do
          expect(documents.count).to eq(0) 
        end
      end

      context 'when the search term is a phrase' do
        let(:document_type) { 'insight' }
        let(:keyword) { 'Financial well being: the employee view' }

        it 'returns an array of documents which contain the phrase' do
          expect(documents).to match_array([insight_page1])
        end
      end
    end
  end
end
