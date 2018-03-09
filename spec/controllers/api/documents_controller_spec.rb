RSpec.describe API::DocumentsController, type: :request do
  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:response_body) { JSON.load(response.body) }
  let(:documents) { response_body['documents'] }
  let(:meta_data) { response_body['meta'] }
  let(:url) { '/api/en/documents' }
  let(:insight_page_params) { {site: site, layout: insight_layout } }
  let(:review_layout)  { create :layout, identifier: 'review' }
  let(:insight_layout) { create :layout, identifier: 'insight' }
  let!(:insight_page1) { create(:insight_page_about_financial_wellbeing, insight_page_params) }
  let!(:insight_page2) { create(:insight_page_about_debt, insight_page_params) }
  let!(:insight_page3) { create(:insight_page_about_pensions, insight_page_params) }
  let!(:insight_page4) { create(:insight_page_titled_annuity, insight_page_params) }
  let!(:insight_page5) { create(:insight_page_titled_annuity2, insight_page_params) }
  let!(:insight_page6) { create(:insight_page_about_annuity, insight_page_params) }
  let!(:review_page1) { create(:page, site: site, layout: review_layout) }

  before do
    allow_any_instance_of(PageSerializer)
      .to receive(:related_content).and_return({})

    get url, params
  end

  describe 'GET /:locale/documents' do
    context 'when all documents are requested' do
      let(:params) { {} }

      it 'returns all documents' do
        expect(meta_data['results']).to eq 7
        expect(documents.count).to eq 7
      end
    end

    context 'when documents of type insight are requested' do
      let(:params) { { document_type: 'insight' } }
      it 'returns all insight documents' do
        expect(meta_data['results']).to eq 6
        expect(documents.count).to eq 6
      end
    end
  end

  describe 'keyword search' do
    context 'when the document_type is specified' do
      context 'when a keyword is provided' do
        context 'and the keyword is found in the content' do
          let(:params) { { document_type: 'insight', keyword: 'pension' } }

          it 'returns an array of documents which contain the keyword' do
            expect(meta_data['results']).to eq 1
            expect(params[:keyword]).to be_in(
              documents.first["blocks"].first["content"]
            )
          end
        end

        context 'and the keyword is found in the middle of the title' do
          let(:params) { { document_type: 'insight', keyword: 'stress' } }

          it 'returns documents with the keyword in the title' do
            expect(params[:keyword]).to be_in(documents.first["label"])
          end
        end

        context 'and the keyword is found at the start of the title' do
          let(:params) { { document_type: 'insight', keyword: 'annuity' } }

          it 'returns documents with the keyword at the start of the title' do
            expect(documents.first["label"]).to start_with(params[:keyword])
          end
        end

        context 'when the keyword is in the title of one document and content of another' do
          let(:params) { { document_type: 'insight', keyword: 'annuity' } }

          it 'returns all the documents' do
            documents.each do |doc|
              doc_title = doc['label']
              doc_content = doc['blocks'].select do |block|
                block['identifier'] =='content' && block['content']
              end.map{|block| block['content']}

              results = [doc_title, doc_content].flatten

              expect(results.any?{|result| result.include?(params[:keyword])}).to be_truthy
            end
          end
        end
      end

      context 'when the keyword is not found' do
        let(:params) { { document_type: 'insight', keyword: 'nosuchterm' } }

        it 'returns an empty array' do
          expect(meta_data['results']).to eq 0
          expect(documents.count).to eq 0
        end
      end

      context 'when the search term is a phrase' do
        let(:params) do
          {
            document_type: 'insight', 
            keyword: 'Financial well being: the employee view' 
          }
        end

        it 'returns an array of documents which contain the phrase' do
          expect(params[:keyword]).to be_in(
            documents.first["blocks"].first["content"]
          )
        end
      end
    end
  end
end
