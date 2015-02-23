describe PagesHelper do
  class Tester
    include PagesHelper
  end

  describe '#page_form_component' do
    subject(:page_form_component) do
      Tester.new.page_form_component(
        page,
        default: ['URLFormatter'],
        optional: ['MirrorInputValue']
      )
    end

    context 'new record' do
      let(:page) { double(new_record?: true) }
      let(:expected) { { dough_component: 'URLFormatter MirrorInputValue' } }

      it 'returns a dough component hash with optional and default components' do
        expect(page_form_component).to eq(expected)
      end
    end

    context 'existing record' do
      let(:page) { double(new_record?: false) }
      let(:expected) { { dough_component: 'URLFormatter' } }

      it 'returns a dough component hash with only default components' do
        expect(page_form_component).to eq(expected)
      end
    end
  end

  describe '#page_slug' do
    before do
      allow(helper).to receive(:preview_domain).and_return('example.com')
    end

    let(:site) { 'en' }
    let(:page) { 'slug' }
    let(:presenter) { 'articles' }
    let(:expected) do
      'example.com/en/<span data-dough-urlformatter-url-display="true">articles/slug</span>'
    end

    it 'returns an article URL' do
      expect(helper.page_slug(site, presenter, page)).to eq(expected)
    end
  end
end
