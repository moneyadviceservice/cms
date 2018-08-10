describe PageContentRegister do
  let(:site) { double(locale: 'en') }
  let(:author) { double }

  subject(:page_content_register) do
    PageContentRegister.new(
      page,
      author: author,
      new_blocks_attributes: new_blocks_attributes
    )
  end

  describe '#new_blocks_attributes' do
    subject do
      page_content_register.new_blocks_attributes
    end

    let(:page) { double(layout: layout, site: site) }
    let(:new_blocks_attributes) do
      [{ content: 'super awesome content' }]
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

  describe '#update_blocks!' do
    let(:author) { create(:user) }
    let!(:page) { create(:page) }
    let!(:content) do
      create(:block, identifier: 'content', content: '', blockable: page)
    end

    let!(:year_of_publication) do
      create(:block, identifier: 'year_of_publication', content: '', blockable: page)
    end
    let!(:topics) do
      create(:block, identifier: 'topics', content: 'Saving', blockable: page)
    end

    let!(:client_groups) do
      create(:block, identifier: 'client_groups', content: 'Young People', blockable: page)
    end

    before(:each) do
      page.reload
      page_content_register.update_blocks!
      page.reload
    end

    context 'content and single blocks' do
      context 'empty starting blocks' do
        context 'no content' do
          let(:new_blocks_attributes) do
            [
              { identifier: 'content', content: '' },
              { identifier: 'year_of_publication', content: '' }
            ]
          end

          it 'keeps the blocks with empty content' do
            expect(page.blocks.size).to be(2)
            expect(page.blocks.first).to eq(content)
            expect(page.blocks.second).to eq(year_of_publication)
          end
        end

        context 'adding content' do
          let(:new_blocks_attributes) do
            [
              { identifier: 'content', content: 'new content' },
              { identifier: 'year_of_publication', content: '2010' }
            ]
          end

          it 'updates the same blocks with new content' do
            expect(page.blocks.map(&:content)).to eq ['new content', '2010']
            expect(page.blocks.size).to be(2)
          end
        end
      end

      context 'content filled starting blocks' do
        let!(:content) do
          create(:block, identifier: 'content', content: 'block content', blockable: page)
        end

        let!(:year_of_publication) do
          create(:block, identifier: 'year_of_publication', content: '2010', blockable: page)
        end

        context 'updating with new content' do
          let(:new_blocks_attributes) do
            [
              { identifier: 'content', content: 'new block content' },
              { identifier: 'year_of_publication', content: '2011' }
            ]
          end

          it 'updates the same blocks' do
            expect(page.blocks.map(&:content)).to eq ['new block content', '2011']
            expect(page.blocks.size).to be(2)
          end
        end

        context 'deleting content' do
          let(:new_blocks_attributes) do
            [
              { identifier: 'content', content: '' },
              { identifier: 'year_of_publication', content: '' }
            ]
          end

          it 'updates the same blocks, but does not delete the block' do
            expect(page.blocks.map(&:content)).to eq ['', '']
            expect(page.blocks.size).to be(2)
          end
        end
      end
    end

    context 'multiple blocks (collections)' do
      context 'when no content in new_blocks_attributes' do
        let(:new_blocks_attributes) do
          [
            { identifier: 'topics', collection: true },
            { identifier: 'client_groups', content: '', collection: true }
          ]
        end

        it 'does not save' do
          expect(page.blocks.size).to be(0)
        end
      end

      context 'adding new blocks' do
        let(:new_blocks_attributes) do
          [
            { identifier: 'topics', content: 'Saving', collection: true },
            { identifier: 'client_groups', content: 'Young People', collection: true }
          ]
        end

        it 'creates new block' do
          expect(page.blocks.map(&:content)).to eq ['Saving', 'Young People']
          expect(page.blocks.size).to be(2)
        end
      end

      context 'adding multiple blocks of same identifier' do
        let(:new_blocks_attributes) do
          [
            { identifier: 'client_groups', content: 'Young People', collection: true },
            { identifier: 'client_groups', content: 'Pensioners', collection: true }
          ]
        end

        it 'saves all blocks' do
          expect(page.blocks.map(&:content)).to eq ['Young People', 'Pensioners']
          expect(page.blocks.map(&:identifier)).to eq %w[client_groups client_groups]
        end
      end

      context 'removing content' do
        let(:new_blocks_attributes) do
          [
            { identifier: 'topics', content: 'Saving', collection: true },
            { identifier: 'client_groups', collection: true },
            { identifier: 'client_groups', content: '', collection: true }
          ]
        end

        it 'deletes empty block' do
          expect(page.blocks.map(&:content)).to eq ['Saving']
          expect(page.blocks.map(&:identifier)).to eq ['topics']
        end
      end
    end

    context 'when updating the same blocks with same info' do
      let(:new_blocks_attributes) do
        [
          { identifier: 'content', content: 'block content' },
          { identifier: 'year_of_publication', content: '2010' },
          { identifier: 'topics', content: 'Saving', collection: true },
          { identifier: 'client_groups', content: 'Young People', collection: true }
        ]
      end

      it 'updates the same block identifiers' do
        expect(page.blocks.size).to be(4)
        expect(page.blocks.first).to eq(content)
        expect(page.blocks.second).to eq(year_of_publication)
        expect(page.blocks.third).to eq(topics)
        expect(page.blocks.fourth).to eq(client_groups)
      end
    end

    context 'when updating the same single blocks with different info' do
      let(:new_blocks_attributes) do
        [
          { identifier: 'content', content: 'new block content' },
          { identifier: 'year_of_publication', content: '2011' },
          { identifier: 'topics', content: 'Pensions', collection: true },
          { identifier: 'client_groups', content: 'Old People', collection: true }
        ]
      end

      it 'updates the same block identifiers' do
        expect(page.blocks.size).to be(4)
        expect(page.blocks.map(&:content)).to eq ['new block content', '2011', 'Pensions', 'Old People']
      end
    end

    context 'when adding new blocks' do
      let (:new_blocks_attributes) do
        [
          { identifier: 'content', content: 'new block content' },
          { identifier: 'topics', content: 'Pensions', collection: true },
          { identifier: 'client_groups', content: 'Old People', collection: true },
          { identifier: 'new_block', content: 'New block' }
        ]
      end

      it 'updates the same block identifiers' do
        expect(page.blocks.size).to be(4)
        expect(page.blocks.map(&:content)).to eq ['new block content', 'New block', 'Pensions', 'Old People']
      end
    end

    context 'when passing same identifier multiple times' do
      let(:new_blocks_attributes) do
        [
          { identifier: 'content', content: 'new block content' },
          { identifier: 'topics', content: 'Saving', collection: true },
          { identifier: 'client_groups', content: 'Young People', collection: true },
          { identifier: 'client_groups', content: 'Pensioners', collection: true }
        ]
      end

      it 'do not overwrite the blocks with same identifier' do
        expect(page.blocks.map(&:content)).to eq ['new block content', 'Saving', 'Young People', 'Pensioners']
        expect(page.blocks.map(&:identifier)).to eq %w[content topics client_groups client_groups]
      end
    end

    context 'removing blocks' do
      let(:new_blocks_attributes) do
        [
          { identifier: 'content', content: 'new block content' },
          { identifier: 'topics', content: '', collection: true }
        ]
      end

      it 'the blocks are removed from the database' do
        expect(page.blocks.map(&:content)).to eq ['new block content']
      end
    end
  end
end
