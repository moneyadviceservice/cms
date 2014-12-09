RSpec.describe LinksController do
  let(:response_body) { JSON.load(response.body).symbolize_keys }

  describe 'GET /links/:url' do
    let(:linkable_object) { LinkableObject.new(object, url) }
    let(:url) { 'some/url' }
    let(:object) { build(:page) }

    before do
      allow(LinkableObject).to receive(:find).with(url).and_return(linkable_object)
      get :show, id: url
    end

    it 'returns the linkable object representation' do
      expect(response_body).to eq(label: object.label, url: url, type: 'page')
    end
  end
end
