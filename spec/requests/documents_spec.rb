RSpec.describe 'documents endpoint', type: :request do
  describe 'GET api/en/documents' do
    let!(:site) { create(:site, path: 'en') }

    let(:headers) do
      {
        'HTTP_AUTHORIZATION' =>
          ActionController::HttpAuthentication::Token.encode_credentials(
            'mytoken'
          )
      }
    end

    context 'when filters is less than maximum number allowed' do
      let(:blocks) { [{ identifier: 'bar', value: 'bar' }] }

      it 'returns success' do
        get 'api/en/documents', { blocks: blocks }, headers

        expect(response.status).to eq(200)
      end
    end

    context 'when filters is greater than maximum number allowed' do
      let(:blocks) do
        Array.new(27) {{ identifier: 'bar', value: 'bar' }}
      end

      it 'returns bad request' do
        get 'api/en/documents', { blocks: blocks }, headers

        expect(response.status).to eq(400)
      end
    end
  end
end
