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

    context 'user is an editor' do
      let(:user) { FactoryGirl.build(:user, role: Comfy::Cms::User.roles[:editor]) }

      it 'returns false' do
        expect(helper.display_additional_button_menu?(page, user)).to be(false)
      end
    end

    context 'user is not an editor' do
      let(:user) { FactoryGirl.build(:user, role: Comfy::Cms::User.roles[:user]) }

      context 'and the page is in the state "unsaved"' do
        before { allow(page).to receive(:unsaved?) { true } }

        it 'returns false' do
          expect(helper.display_additional_button_menu?(page, user)).to be(false)
        end
      end

      context 'and the page not in the state "unsaved"' do
        before { allow(page).to receive(:unsaved?) { false } }

        context 'and the page is in the state "unpublished"' do
          before { allow(page).to receive(:unpublished?) { true } }

          it 'returns false' do
            expect(helper.display_additional_button_menu?(page, user)).to be(false)
          end
        end

        context 'and the page not in the state "unpublished"' do
          before { allow(page).to receive(:unpublished?) { false } }

          it 'returns true' do
            expect(helper.display_additional_button_menu?(page, user)).to be(true)
          end
        end
      end
    end
  end

  describe '#display_metadata_form_fields?' do
    let(:page) { FactoryGirl.build(:page, layout: layout) }

    context 'page layout is not a footer or home page' do
      let(:layout) { FactoryGirl.build(:layout, identifier: 'article') }

      it { expect(helper.display_metadata_form_fields?(page)).to be(true) }
    end

    context 'page layout is a footer' do
      let(:layout) { FactoryGirl.build(:layout, identifier: 'footer') }

      it { expect(helper.display_metadata_form_fields?(page)).to be(false) }
    end

    context 'page layout is a home page' do
      let(:layout) { FactoryGirl.build(:layout, identifier: 'home_page') }

      it { expect(helper.display_metadata_form_fields?(page)).to be(false) }
    end

    context 'page layout is an offline page' do
      let(:layout) { FactoryGirl.build(:layout, identifier: 'offline_page') }

      it { expect(helper.display_metadata_form_fields?(page)).to be(false) }
    end
  end
end
