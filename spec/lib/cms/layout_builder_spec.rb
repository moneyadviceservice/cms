RSpec.describe Cms::LayoutBuilder do
  let!(:english_site) { create(:site, is_mirrored: true) }
  let!(:welsh_site)   { create(:site, :welsh, is_mirrored: true) }

  describe '.add_home_page!' do
    before { Cms::LayoutBuilder.add_home_page! }

    context 'English site' do
      let(:layout) { english_site.layouts.reload.first }

      it 'creates a layout for the English site' do
        expect(english_site.layouts.count).to eq(1)
      end

      it 'sets the label for the layout to be "Home Page"' do
        expect(layout.label).to eq('Home Page')
      end

      it 'sets the identifier for the layout to be home_page' do
        expect(layout.identifier).to eq('home_page')
      end

      it 'defines the content areas for the home page layout' do
        expect(layout.content).to include('{{ cms:page:raw_heading:string }}')
        expect(layout.content).to include('{{ cms:page:raw_hero_image:image }}')
        expect(layout.content).to include('{{ cms:page:raw_bullet_1:string }}')
        expect(layout.content).to include('{{ cms:page:raw_bullet_2:string }}')
        expect(layout.content).to include('{{ cms:page:raw_bullet_3:string }}')
        expect(layout.content).to include('{{ cms:page:raw_cta_text:string }}')
        expect(layout.content).to include('{{ cms:page:raw_cta_link:string }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_1_heading }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_1_url }}')
        expect(layout.content).to include('{{ cms:page:raw_tool_1_text }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_2_heading }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_2_url }}')
        expect(layout.content).to include('{{ cms:page:raw_tool_2_text }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_3_heading }}')
        expect(layout.content).to include('{{ cms:field:raw_tool_3_url }}')
        expect(layout.content).to include('{{ cms:page:raw_tool_3_text }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_1_heading }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_1_image:image }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_1_url }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_1_label }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_1_content }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_2_heading }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_2_image:image }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_2_url }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_2_label }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_2_content }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_3_heading }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_3_image:image }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_3_url }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_3_label }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_3_content }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_4_heading }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_4_image:image }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_4_url }}')
        expect(layout.content).to include('{{ cms:field:raw_tile_4_label }}')
        expect(layout.content).to include('{{ cms:page:raw_tile_4_content }}')
        expect(layout.content).to include('{{ cms:field:raw_text_tile_1_heading }}')
        expect(layout.content).to include('{{ cms:field:raw_text_tile_1_url }}')
        expect(layout.content).to include('{{ cms:page:raw_text_tile_1_content }}')
        expect(layout.content).to include('{{ cms:field:raw_text_tile_2_heading }}')
        expect(layout.content).to include('{{ cms:field:raw_text_tile_2_url }}')
        expect(layout.content).to include('{{ cms:page:raw_text_tile_2_content }}')
        expect(layout.content).to include('{{ cms:field:raw_promo_banner_content }}')
        expect(layout.content).to include('{{ cms:field:raw_promo_banner_url }}')
      end
    end

    context 'Welsh site' do
      let(:layout) { welsh_site.layouts.reload.first }

      it 'creates a layout for the Welsh site' do
        expect(welsh_site.layouts.count).to eq(1)
      end

      it 'sets the label for the layout to be "Home Page"' do
        expect(layout.label).to eq('Home Page')
      end

      it 'sets the label for the layout to be "Home Page"' do
        expect(layout.identifier).to eq('home_page')
      end

      it 'uses the same content areas as the english layout' do
        english_layout = english_site.layouts.reload.first
        expect(layout.content).to eq(english_layout.content)
      end
    end
  end

  describe '.add_contact_panels!' do
    before { Cms::LayoutBuilder.add_contact_panels! }

    context 'English site' do
      let(:layout) { english_site.layouts.reload.first }

      it 'creates a layout for the English site' do
        expect(english_site.layouts.count).to eq(1)
      end

      it 'sets the label for the layout to be "Contact Panels"' do
        expect(layout.label).to eq('Contact Panels')
      end

      it 'sets the identifier for the layout to be contact_panels' do
        expect(layout.identifier).to eq('contact_panels')
      end

      it 'defines the content areas for the home page layout' do
        expect(layout.content).to include('{{ cms:page:web_chat_times }}')
      end
    end

    context 'Welsh site' do
      let(:layout) { welsh_site.layouts.reload.first }

      it 'creates a layout for the Welsh site' do
        expect(welsh_site.layouts.count).to eq(1)
      end

      it 'sets the label for the layout to be "Contact Panels"' do
        expect(layout.label).to eq('Contact Panels')
      end

      it 'sets the identifier for the layout to be contact_panels' do
        expect(layout.identifier).to eq('contact_panels')
      end

      it 'uses the same content areas as the english layout' do
        english_layout = english_site.layouts.reload.first
        expect(layout.content).to eq(english_layout.content)
      end
    end
  end

end
