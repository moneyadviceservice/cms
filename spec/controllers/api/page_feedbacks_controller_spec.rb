RSpec.describe API::PageFeedbacksController, type: :controller do
  let(:site) { create(:site, path: 'en') }
  let(:page) { create(:page, site: site) }

  before do
    controller.request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials('mytoken')
  end

  describe 'API authentication' do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials('fake')
      post :create, params
    end

    context 'when token is invalid' do
      let(:params) do
        {
          slug: page.slug,
          liked: true,
          session_id: '5cfe12kc',
          locale: 'en'
        }
      end

      it 'returns 401' do
        expect(response.status).to be(401)
      end

      it 'add www-authenticate header' do
        expect(response.headers).to include(
          'WWW-Authenticate' => 'Token realm="Application"'
        )
      end
    end
  end

  describe 'POST /en/articles/slug/page_feedbacks' do
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
        expect(JSON.parse(response.body)).to include(
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
        expect(JSON.parse(response.body)).to include(
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
        expect(JSON.parse(response.body)).to include(
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
        expect(JSON.parse(response.body)).to include(
          'errors' => ["Session can't be blank"]
        )
      end
    end
  end

  describe 'PATCH /en/articles/slug/page_feedback' do
    before do
      patch :update, params.merge(locale: 'en')
    end

    context 'when page feedback exists' do
      let!(:page_feedback) do
        create(:page_feedback, page_id: page.id)
      end

      context 'when is valid' do
        let(:params) do
          {
            session_id: page_feedback.session_id,
            slug: page.slug,
            comment: 'Terrible article!',
            shared_on: 'Facebook'
          }
        end

        it 'returns success response' do
          expect(response.status).to be(200)
        end

        it 'returns page feedback' do
          expect(JSON.parse(response.body)).to include(
            'liked'     => true,
            'comment'   => 'Terrible article!',
            'shared_on' => 'Facebook'
          )
        end
      end

      context 'when is invalid' do
        let(:params) do
          {
            session_id: page_feedback.session_id,
            slug: page.slug
          }
        end

        before do
          expect_any_instance_of(PageFeedback).to receive(:update).and_return(false)
          patch :update, params.merge(locale: 'en')
        end

        it 'returns unprocessable entity' do
          expect(response.status).to be(422)
        end

        it 'includes message node' do
          expect(JSON.parse(response.body)).to include(
            'message' => []
          )
        end
      end
    end

    context 'when page feedback does not exists' do
      let(:params) do
        { session_id: 'inexistent', slug: page.slug }
      end

      it 'returns page not found' do
        expect(response.status).to be(404)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to include(
          'message' => %(Page feedback "#{page.slug}" not found)
        )
      end
    end
  end
end
