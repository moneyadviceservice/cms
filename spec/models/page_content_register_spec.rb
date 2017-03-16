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
      let(:new_blocks_attributes) do
        [
          { content: 'super awesome content' },
          { identifier: 'raw_tile_1_image', content: 'http://e.co/original/img.png' }
        ]
      end

      context "when identifier is 'raw_tile_\d_image'" do
        let(:blocks_contents) do
          subject.map { |b| b[:content] }
        end
        let(:blocks_identifiers) do
          subject.map { |b| b[:identifier] }
        end

        it 'retains original image identifier' do
          expect(blocks_identifiers).to include('raw_tile_1_image')
        end

        it 'retains original image content' do
          expect(blocks_contents).to include('http://e.co/original/img.png')
        end

        it "replaces identifier 'image' with 'srcset'" do
          expect(blocks_identifiers).to include('raw_tile_1_srcset')
        end

        it 'contains all available styles' do
          blocks_contents = subject.map { |b| b[:content] }
          content = <<-CONTENT
            http://e.co/extra_small/img.png 390w,
            http://e.co/small/img.png 485w,
            http://e.co/medium/img.png 900w,
            http://e.co/large/img.png 1350w
          CONTENT
          expect(blocks_contents).to include(content.split(',').map(&:strip).join(', '))
        end
      end
    end

    context 'when page is footer' do
      let(:layout) { double(identifier: 'footer') }

      it 'returns processed content as blank' do
        expect(subject).to eq(new_blocks_attributes)
      end
    end
  end
end
