describe Publify::API do

  describe 'latest links' do
    PUBLIFY_HOSTNAME = 'example.com'

    context 'when successfully getting a response from Publify' do
      let(:expected_uri) { URI('http://example.com/articles.json') }
      let(:json) { '[{"title": "newest blog post"}, {"title": "oldest blog post"}]' }

      before do
        allow(Net::HTTP).to receive(:get).with(expected_uri).and_return(json)
      end

      it 'provides the latest blog posts' do
        result = described_class.latest_links(2)
        expect(result.length).to eq(2)
      end

      it 'maintains order of blog posts from publify' do
        result = described_class.latest_links(2)
        expect(result.first['title']).to eq('newest blog post')
      end

      it 'restricts the limit of blog posts requested' do
        result = described_class.latest_links(1)
        expect(result.length).to eq(1)
      end
    end

    context 'when there has been an exception' do

      it 'gracefully returns an empty array' do
        allow(Net::HTTP).to receive(:get).and_raise('Failed to reach Publify')
        expect(described_class.latest_links(2)).to be_empty
      end

      it 'gracefully returns an empty array when there has been an exception' do
        allow(Net::HTTP).to receive(:get).and_raise('Failed to reach Publify')
        expect(Rails.logger).to receive(:error).with('Failed to reach Publify')

        described_class.latest_links(2)
      end

    end

  end

end
