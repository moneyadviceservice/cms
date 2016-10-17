RSpec.describe API::PageFeedbacksController do
  describe 'POST /page_feedbacks' do
    let(:site) { create(:site, path: 'en') }
    let(:page) { create(:page, site: site) }
    before { post :create, params }

    context 'when the page receives a like' do
      let(:params) do
        {
          slug: page.slug,
          liked: true,
          session_id: '5cfe12kc',
          locale: 'en'
        }
      end

      it 'returns created resource' do
        expect(response.status).to be(201)
      end

      it 'creates liked page feedback' do
        expect(page.feedbacks.count).to be(1)
        expect(page.feedbacks.last).to be_liked
      end

      it 'returns JSON in response body' do
        expect(JSON.load(response.body)).to include(
          'liked'      => true,
          'session_id' => '5cfe12kc'
        )
      end
    end

    context 'when the page receives a dislike' do
      let(:params) do
        {
          slug: page.slug,
          liked: false,
          session_id: '5cfe12kc',
          locale: 'en'
        }
      end

      it 'returns created resource' do
        expect(response.status).to be(201)
      end

      it 'creates liked page feedback' do
        expect(page.feedbacks.count).to be(1)
        expect(page.feedbacks.last).to_not be_liked
      end
    end

    context 'when passing an inexistent locale' do
      let(:params) do
        {
          slug: page.slug,
          liked: true,
          locale: 'pt-br',
          session_id: 'CVtuSY'
        }
      end

      it 'returns 404 not found' do
        expect(response.status).to be(404)
      end

      it 'returns inexistent site' do
        expect(JSON.load(response.body)).to include(
          'message' => 'Site "pt-br" not found'
        )
      end
    end

    context 'when passing an inexistent page' do
      let(:params) do
        {
          slug: 'inexistent',
          liked: true,
          locale: page.site.path
        }
      end

      it 'returns not found' do
        expect(response.status).to be(404)
      end

      it 'returns message about inexistent page' do
        expect(JSON.load(response.body)).to include(
          'message' => 'Page "inexistent" not found'
        )
      end
    end

    describe 'when passing a blank session' do
      let(:params) do
        {
          slug: page.slug,
          liked: true,
          locale: 'en'
        }
      end

      it 'returns unprocessable entity' do
        expect(response.status).to be(422)
      end

      it 'returns error message in response body' do
        expect(JSON.load(response.body)).to include(
          'errors' => ["Session can't be blank"]
        )
      end
    end
  end
end
