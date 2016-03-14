describe FeedPageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site) }
  subject { described_class.new(article) }

  describe '#related_content' do
    it 'returns no related content' do
      expect(subject.related_content).to eql({})
    end
  end
end
