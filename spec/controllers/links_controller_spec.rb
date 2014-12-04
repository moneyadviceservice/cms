RSpec.describe LinksController do
  describe 'GET /links/:url' do
    let(:url) { 'some/url' }
    let(:link_type) { 'page' }

    before do
      allow(LinkableObject).to receive(:find).with(url, link_type: link_type).and_return(object)
      get :show, id: url, type: link_type
    end

    context 'when finds the linkable object' do
      let(:object) { build(:page, label: 'Before borrow money') }

      it 'returns the label of the page' do
        expect(response.body).to eq(JSON.dump(label: object.label))
      end
    end

    context 'when not find the linkable object' do
      let(:object) { nil }

      it 'returns not found' do
        expect(response.status).to be 404
      end
    end
  end
end