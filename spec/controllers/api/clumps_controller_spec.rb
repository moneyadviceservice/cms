RSpec.describe API::ClumpsController, type: :request do
  describe 'GET /api/:locale/clumps' do
    before do
      FactoryGirl.create(:clump, name_en: 'Debt', name_cy: 'Debt-cy')
      FactoryGirl.create(:clump, name_en: 'Retirement', name_cy: 'Retirement-cy')
    end

    context 'en locale' do
      before { FactoryGirl.create(:site, path: 'en') }

      it 'returns all clumps using the appropriate locale' do
        get '/api/en/clumps'

        expect(response).to have_http_status :ok
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq 2
        expect(response_body.map { |clump| clump['name'] }).to eq(%w(Debt Retirement))
      end
    end

    context 'cy locale' do
      before { FactoryGirl.create(:site, path: 'cy') }

      it 'returns all clumps using the appropriate locale' do
        get '/api/cy/clumps'

        expect(response).to have_http_status :ok
        response_body = JSON.parse(response.body)
        expect(response_body.length).to eq 2
        expect(response_body.map { |clump| clump['name'] }).to eq(%w(Debt-cy Retirement-cy))
      end
    end
  end
end
