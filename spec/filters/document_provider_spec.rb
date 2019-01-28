RSpec.describe DocumentProvider do
  subject do
    described_class.new(
      current_site: site,
      document_type: document_type,
      keyword: keyword,
      blocks: filters,
      tag: tag,
      order_by_date: order_by_date
    ).retrieve
  end

  let!(:site) do
    create(:site, path: 'en', locale: 'en', is_mirrored: true)
  end

  let(:document_type) { nil }
  let(:keyword) { nil }
  let(:filters) { nil }
  let(:tag) { nil }
  let(:order_by_date) { nil }

  let(:insight_layout) { create :layout, identifier: 'insight' }
  let(:news_layout) { create :layout, identifier: 'news' }
  let(:review_layout) { create :layout, identifier: 'review' }

  describe 'no filtering' do
    let!(:insight_page) { create(:insight_page, site: site, layout: insight_layout) }
    let!(:review_page) { create(:page, site: site, layout: review_layout) }
    let!(:home_page) { create(:homepage) }

    it 'returns insight, review or evaluation pages' do
      expect(subject.size).to eq(2)
      expect(subject).to match_array([insight_page, review_page])
    end
  end

  describe 'filter_by_type' do
    let!(:insight_page) { create(:insight_page, site: site, layout: insight_layout) }
    let!(:review_page) { create(:page, site: site, layout: review_layout) }

    let(:document_type) { 'review' }

    it 'returns all documents of a given type' do
      expect(subject.size).to eq(1)
      expect(subject).to match_array([review_page])
    end
  end

  describe 'filter_by_tag' do
    let!(:tagged_page) { create(:page_with_tag, site: site, layout: insight_layout) }
    let!(:untagged_page) { create(:english_article, site: site, layout: insight_layout) }
    let(:document_type) { 'insight' }

    context 'with a single tag' do
      let(:tag) { ['tag'] }

      it 'returns all documents tagged' do
        expect(subject.size).to eq(1)
        expect(subject).to match_array([tagged_page])
      end
    end

    context 'with multiple tags' do
      let!(:another_tagged_page) { create(:page_with_multiple_tags, site: site, layout: insight_layout) }
      let(:tag) { ['tag', 'tag-2'] }

      it 'returns the tagged pages' do
        expect(subject.size).to eq(2)
        expect(subject).to match_array([tagged_page, another_tagged_page])
      end
    end
  end

  describe 'filter_by_keyword' do
    context 'when a keyword is provided' do
      context 'searching the title' do
        context 'and the keyword is equal to the page title' do
          let!(:page_entitled_keyword) { create(:insight_page_titled_annuities, site: site, layout: insight_layout) }
          let!(:page_not_entitled_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { 'Annuities' }

          it 'returns documents where the keyword is the document title' do
            expect(subject.size).to eq(1)
            expect(subject).to match_array([page_entitled_keyword])
          end
        end

        context 'and the keyword is found in the middle of the title' do
          let!(:page_entitled_keyword) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
          let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { 'stress' }

          it 'returns documents with the keyword in the title' do
            expect(subject.count).to eq(1)
            expect(subject).to match_array([page_entitled_keyword])
          end
        end

        context 'and the keyword is found at the start of the title' do
          let!(:page_entitled_keyword) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
          let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { 'debt' }

          it 'returns documents with the keyword in the title' do
            expect(subject.count).to eq(1)
            expect(subject).to match_array([page_entitled_keyword])
          end
        end
      end

      context 'searching the content' do
        context 'and the keyword is found in an "overview" block' do
          let!(:page_with_keyword) { create(:insight_page_with_overview_block, site: site, layout: insight_layout) }
          let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { 'redundancy' }

          it 'returns only those documents' do
            expect(subject.size).to eq(1)
            expect(subject).to match_array([page_with_keyword])
          end
        end

        context 'and the keyword is found in a "content" block' do
          let!(:page_with_keyword) { create(:insight_page_with_overview_block, site: site, layout: insight_layout) }
          let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { 'redundancy' }

          it 'returns only those documents' do
            expect(subject.size).to eq(1)
            expect(subject).to match_array([page_with_keyword])
          end
        end

        context 'and the keyword is found in an "order_by_date" block' do
          let!(:page_with_order_by_date_block) do
            create(:page_with_order_by_date_block, site: site, layout: insight_layout)
          end
          let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
          let(:keyword) { '2017' }

          it 'returns only those documents' do
            expect(subject.size).to eq(1)
            expect(subject).to match_array([page_with_order_by_date_block])
          end
        end

        context 'and the keyword is found in a block that is not content or overview' do
          let!(:page_with_keyword) { create(:insight_page_with_raw_cta_text_block, site: site, layout: insight_layout) }
          let(:keyword) { 'random' }

          it 'does not return the document' do
            expect(subject.count).to eq(0)
          end
        end
      end
    end

    context 'and the keyword is in the title of one document and content of another' do
      let!(:page_entitled_keyword) { create(:insight_page_titled_pensions, site: site, layout: insight_layout) }
      let!(:page_with_keyword) { create(:insight_page_about_pensions, site: site, layout: insight_layout) }
      let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }

      let(:keyword) { 'pension' }

      it 'returns both documents' do
        expect(subject.size).to eq(2)
        expect(subject).to match_array([page_entitled_keyword, page_with_keyword])
      end
    end

    context 'when the keyword is not found' do
      let!(:page_without_keyword) { create(:page, site: site, layout: insight_layout) }
      let(:keyword) { 'nosuchterm' }

      it 'returns an empty array' do
        expect(subject.count).to eq(0)
      end
    end

    context 'when the search term is a phrase' do
      let!(:page_with_phrase) { create(:insight_page, site: site, layout: insight_layout) }
      let!(:page_without_phrase) { create(:page, site: site, layout: insight_layout) }
      let(:keyword) { 'Financial well being: the employee view' }

      it 'returns an array of documents which contain the phrase' do
        expect(subject.size).to eq(1)
        expect(subject).to match_array([page_with_phrase])
      end
    end
  end

  describe 'filtering search results' do
    context 'when there is only one value for the filter type' do
      let!(:page_with_filter_type) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
      let!(:page_without_filter_type) { create(:page, site: site, layout: insight_layout) }
      let(:filters) { [{ identifier: 'client_groups', value: 'Working age (18 - 65)' }] }

      it 'returns only documents that meet the filter type' do
        expect(subject.size).to eq(1)
        expect(subject).to match_array([page_with_filter_type])
      end
    end

    context 'when there are multiple values for the filter type' do
      let!(:page_with_filter_type1) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
      let!(:page_with_filter_type2) { create(:young_adults_page, site: site, layout: insight_layout) }
      let!(:page_without_filter_type) { create(:insight_page_about_pensions, site: site, layout: insight_layout) }

      let(:filters) do
        [
          {
            identifier: 'client_groups',
            value: 'Working age (18 - 65)'
          },
          {
            identifier: 'client_groups',
            value: 'Young adults (17 - 24)'
          }
        ]
      end

      it 'returns only documents that meet the filter type' do
        expect(subject.size).to eq(2)
        expect(subject).to match_array([page_with_filter_type1, page_with_filter_type2])
      end

      context 'when there are documents with multiple topic blocks' do
        let!(:page_with_2_filters) { create(:uk_study_about_work_and_stress, site: site, layout: insight_layout) }
        let(:filters) do
          [
            {
              identifier: 'topic',
              value: 'Saving'
            },
            {
              identifier: 'topic',
              value: 'Pensions and retirement planning'
            }
          ]
        end
        it 'returns documents only once' do
          expect(subject.size).to eq(1)
          expect(subject).to match_array([page_with_2_filters])
        end
      end
    end
  end

  describe 'when there is a filter type and a keyword' do
    context 'when there is one filter type' do
      let!(:page_with_filter_type_and_keyword) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
      let!(:page_with_keyword) { create(:young_adults_page, site: site, layout: insight_layout) }
      let!(:page_without_anything) { create(:page, site: site, layout: insight_layout) }

      let(:keyword) { 'debt' }
      let(:filters) { [{ identifier: 'client_groups', value: 'Working age (18 - 65)' }] }

      it 'returns only documents that have the keyword and meet the filter type' do
        expect(subject.size).to eq(1)
        expect(subject).to match_array([page_with_filter_type_and_keyword])
      end
    end

    context 'when there are multiple filters of different types' do
      let!(:page_with_filter_type_and_keyword) { create(:page_abt_debt_and_stress, site: site, layout: insight_layout) }
      let!(:page_with_3_filter_types_and_keyword) do
        create(:uk_study_about_work_and_stress, site: site, layout: insight_layout)
      end
      let!(:page_with_keyword) { create(:young_adults_page, site: site, layout: insight_layout) }
      let!(:page_without_anything) { create(:page, site: site, layout: insight_layout) }

      let(:keyword) { 'stress' }
      let(:filters) { [filter1, filter2, filter3] }
      let(:filter1) { { identifier: 'client_groups', value: 'Working age (18 - 65)' } }
      let(:filter2) { { identifier: 'topic', value: 'Saving' } }
      let(:filter3) { { identifier: 'countries_of_delivery', value: 'United Kingdom' } }

      it 'returns documents that have the keyword and all the given filter types' do
        expect(subject.size).to eq(1)
        expect(subject).to match_array([page_with_3_filter_types_and_keyword])
      end
    end

    context 'when there are multiple filters of the same type' do
      let!(:page_with_3_filter_types_and_keyword) do
        create(:page_abt_debt_and_stress, site: site, layout: insight_layout)
      end
      let!(:page_with_a_diff_filter_and_keyword) { create(:young_adults_page, site: site, layout: insight_layout) }
      let!(:page_without_anything) { create(:page, site: site, layout: insight_layout) }

      let(:keyword) { 'stress' }
      let(:filters) { [filter1, filter2] }
      let(:filter1) { { identifier: 'client_groups', value: 'Working age (18 - 65)' } }
      let(:filter2) { { identifier: 'client_groups', value: 'Young adults (17 - 24)' } }

      it 'returns documents that have the keyword and all the given filter types' do
        expect(subject.size).to eq(2)
        expect(subject).to match_array(
          [page_with_3_filter_types_and_keyword, page_with_a_diff_filter_and_keyword]
        )
      end
    end
  end

  describe 'ordering search results' do
    let!(:news_page1) do
      create(
        :page_with_order_by_date_block,
        site: site,
        layout: news_layout,
        created_at: Date.today,
        order_by_date: '2017-03-15'
      )
    end
    let!(:news_page2) do
      create(
        :page_with_order_by_date_block,
        site: site,
        layout: news_layout,
        created_at: Date.yesterday,
        order_by_date: '2017-03-16'
      )
    end

    context 'when ordering by "order_by_date"' do
      let(:order_by_date) { 'true' }

      it 'returns pages in descending order of "order_by_date"' do
        expect(subject).to eq([news_page2, news_page1])
      end
    end

    context 'when not ordering by "order_by_date"' do
      let(:order_by_date) { 'false' }

      it 'returns pages in descending order of creation date' do
        expect(subject).to eq([news_page1, news_page2])
      end

      it 'prioritizes the creation date over the default cms position value' do
        news_page1.update_attributes(position: 2)
        news_page2.update_attributes(position: 1)

        expect(subject).to eq([news_page1, news_page2])
      end
    end
  end

  describe 'when there are too many filters' do
    let(:filters) { (1..27).to_a }

    it 'returns nothing' do
      expect(subject).to be_nil
    end
  end
end
