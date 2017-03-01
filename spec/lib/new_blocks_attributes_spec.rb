RSpec.describe NewBlocksAttributes do
	describe '#available_styles' do
    let(:page_block_register) { Object.new.extend NewBlocksAttributes }
    let(:new_blocks_attributes) {}

			it 'returns list of styles' do
				styles = page_block_register.available_styles.map{ |h| h[:style] }

				expect(styles).to eq([:extra_small, :small, :medium, :large])
			end

			it 'returns width' do
				widths = page_block_register.available_styles.map{ |h| h[:width] }

				expect(widths).to eq(['390', '485', '900', '1350'])
			end
	end

	describe '#srcset_blocks' do
    let(:page) { create :homepage }
    let(:page_block_register) { Object.new.extend NewBlocksAttributes }

    let(:block) { create(:block,
                         blockable: page,
                         identifier: 'raw_tile_2_image',
                         content: 'http://e.co/original/UC.jpg' ) }

    let!(:actual_blocks) do
      page.blocks << block
      page_block_register.srcset_blocks(input_args: page.blocks_attributes)
    end

    it 'expects page to have image_srcset block' do
      expect(actual_blocks.map{ |b| b[:identifier] }).to include('raw_tile_1_srcset', 'raw_tile_2_srcset')
    end

    it 'expects image srcset to contain correct srcset info' do
      expect(actual_blocks.map{ |b| b[:content] }).to include('http://e.co/extra_small/UC.jpg 390w, http://e.co/small/UC.jpg 485w, http://e.co/medium/UC.jpg 900w, http://e.co/large/UC.jpg 1350w')
    end
  end
end
