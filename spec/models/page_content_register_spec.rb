describe PageContentRegister do
  describe '#new_blocks_attributes' do
    let(:site) { double(locale: 'en') }
    let(:page) { double(layout: layout, site: site) }
    let(:author) { double }
    let(:new_blocks_attributes) do
      [{ content: 'super awesome content' }]
    end

    subject do
      PageContentRegister.new(
        page,
        author: author,
        new_blocks_attributes: new_blocks_attributes
      ).new_blocks_attributes
    end

    context 'when page is an article' do
      let(:layout) { double(identifier: 'article') }

      it 'converts content to html as processed content' do
        expect(subject).to eq([
          {
            content: 'super awesome content',
            processed_content: "<p>super awesome content</p>\n"
          }
        ])
      end
    end

    context 'when page is the homepage' do
      let(:layout) { double(identifier: 'home_page') }

      it 'returns processed content as blank' do
        expect(subject).to eq(new_blocks_attributes)
      end
    end
  end
end
