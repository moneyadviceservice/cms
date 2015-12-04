describe TableOfContents do
  subject do
    described_class.new('<h1>main heading</h1><h2 id="this-is-a-heading">This is a heading</h2><h2 id="this-is-another-heading">This is another heading</h2>')
  end

  describe '#call' do
    it 'add add table of contents' do
      expect(subject.call).to include('<a href="#this-is-a-heading">This is a heading</a>')
      expect(subject.call).to include('<a href="#this-is-another-heading">This is another heading</a>')
    end
  end
end
