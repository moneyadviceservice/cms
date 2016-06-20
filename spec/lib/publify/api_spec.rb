describe Publify::API do

  describe 'latest links' do

    context 'when successfully getting a response from Publify' do
      let(:json) { '[{"title": "newest blog post"}, {"title": "oldest blog post"}]' }
      let(:response) { double(body: json) }

      before do
        ENV['PUBLIFY_HOSTNAME'] = 'example.com'
        ENV['PUBLIFY_PORT'] = '4000'

        allow_any_instance_of(Net::HTTP).to receive(:get).with('/blog/articles.json').and_return(response)
      end

      it 'connects to the specified server' do
        expect(Net::HTTP).to receive(:new).with('example.com', 4000)
        described_class.latest_links(2)
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

      it 'sets up the open timeout limit' do
        expect_any_instance_of(Net::HTTP).to receive(:open_timeout=).with(2)
        described_class.latest_links(2)
      end

      it 'sets up the read timeout limit' do
        expect_any_instance_of(Net::HTTP).to receive(:read_timeout=).with(2)
        described_class.latest_links(2)
      end

    end

    context 'when there has been an exception' do

      it 'gracefully returns an empty array' do
        allow_any_instance_of(Net::HTTP).to receive(:get).and_raise('Failed to reach Publify')
        expect(described_class.latest_links(2)).to be_empty
      end

      it 'gracefully returns an empty array when there has been an exception' do
        allow_any_instance_of(Net::HTTP).to receive(:get).and_raise('Failed to reach Publify')
        expect(Rails.logger).to receive(:error).with('Failed to reach Publify')

        described_class.latest_links(2)
      end

    end

  end

end
