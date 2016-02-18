describe PagesHelper do
  class Tester
    include PagesHelper
  end

  describe '#page_form_component' do
    let(:display) { true }

    subject(:page_form_component) do
      Tester.new.page_form_component(
        condition,
        default: ['URLFormatter'],
        optional: ['MirrorInputValue'],
        display: display
      )
    end

    context 'new record' do
      let(:condition) { true }
      let(:expected) { { dough_component: 'URLFormatter MirrorInputValue' } }

      it 'returns a dough component hash with optional and default components' do
        expect(page_form_component).to eq(expected)
      end
    end

    context 'existing record' do
      let(:condition) { false }
      let(:expected) { { dough_component: 'URLFormatter' } }

      it 'returns a dough component hash with only default components' do
        expect(page_form_component).to eq(expected)
      end
    end

    context 'when it is not displayed' do
      let(:condition) { false }
      let(:display) { false }
      let(:expected) { {} }

      it 'returns an empty hash' do
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

  describe '#display_additional_button_menu?' do
    let(:page) { FactoryGirl.build(:page) }
    let(:user) { FactoryGirl.build(:user, role: Comfy::Cms::User.roles[:user]) }
    let(:buttons) { [double] }
    before { allow(helper).to receive(:page_state_buttons).and_return(buttons) }

    context 'user is an editor' do
      let(:user) { FactoryGirl.build(:user, role: Comfy::Cms::User.roles[:editor]) }

      it 'returns false if the current user is an editor' do
        expect(helper.display_additional_button_menu?(page, user)).to be(false)
      end
    end

    context 'page is publishable and page_state_buttons is empty' do
      let(:buttons) { [] }
      it { expect(helper.display_additional_button_menu?(page, user)).to be(false) }
    end

    context 'page is publishable and page_state_buttons contains something' do
      let(:buttons) { [double] }
      it { expect(helper.display_additional_button_menu?(page, user)).to be(true) }
    end

    context 'page is not publishable' do
      before { allow(page).to receive(:publishable?).and_return(false) }
      it { expect(helper.display_additional_button_menu?(page, user)).to be(false) }
    end
  end
end
