describe Rack::RedirectMiddleware::Responder do
  include Rack::Test::Methods

  def app
    described_class.new(root_app)
  end

  def root_app
    -> (_env) { [200, {}, 'root app'] }
  end

  describe '#call' do
    context 'when redirect does not exist' do
      it 'passes thru' do
        get '/'
        expect(last_response.body).to include('root app')
      end
    end

    context 'when redirect exists' do
      let!(:redirect) do
        Redirect.create!(source: '/en/foo',
                         destination: '/en/bar',
                         redirect_type: 'temporary')
      end

      it 'returns matching redirect status code' do
        get '/api/en/foo.json'
        expect(last_response.status).to eql(redirect.status_code)
      end

      it 'returns location header' do
        get '/api/en/foo.json'
        expect(last_response.headers['Location']).to eql('http://localhost:5000' + redirect.destination)
      end
    end

    extensions = %w(aspx pdf html)

    extensions.each do |extension|
      context "when #{extension} redirect exists" do
        let!(:redirect) do
          Redirect.create!(source: "/en/foo.#{extension}",
                           destination: '/en/bar',
                           redirect_type: 'temporary')
        end

        it 'returns matching redirect status code' do
          get "/api/en/foo.#{extension}"
          expect(last_response.status).to eql(redirect.status_code)
        end

        it 'returns location header' do
          get "/api/en/foo.#{extension}"
          expect(last_response.headers['Location']).to eql('http://localhost:5000' + redirect.destination)
        end
      end
    end

    context 'when some other path' do
      it 'passes thru' do
        get '/api/assets/components-font-awesome/css/font-awesome.css?body=1'
        expect(last_response.body).to include('root app')
      end

      it 'does not perform a db lookup' do
        redirect_class_spy = spy('Redirect')
        stub_const('Redirect', redirect_class_spy)

        get '/api/assets/components-font-awesome/css/font-awesome.css?body=1'
        expect(redirect_class_spy).to_not have_received(:find_by)
      end
    end
  end
end
