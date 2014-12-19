RSpec.describe PagePresenter do
  subject(:presenter) do
    described_class.new(object)
  end

  describe '#language_input_tag' do
    subject(:language_input_tag) do
      presenter.language_input_tag(language)
    end

    let(:object) { create(:page) }

    let(:current_path) do
      Rails.application.routes.url_helpers.edit_site_page_path(object.site, object)
    end

    context 'when is the same site language' do
      let(:language) { :en }

      it 'returns checked input' do
        expect(language_input_tag).to include('input checked="checked"')
      end

      it 'returns the current path in the data attribute on input' do
        expect(language_input_tag).to include(%(data-value="#{current_path}"))
      end
    end

    context 'when is other site language' do
      let(:language) { :cy }
      let(:mirror) { create(:page, site: create(:site, :welsh)) }

      before do
        allow(object).to receive(:mirrors).and_return([mirror])
      end

      it 'returns not checked input' do
        expect(language_input_tag).to_not include('checked')
      end

      it 'returns mirror edit site page path' do
        expected = %(data-value="/admin/sites/#{mirror.site.id}/pages/#{mirror.id}/edit")
        expect(language_input_tag).to include(expected)
      end
    end

    context 'when other language does not exist' do
      let(:language) { :cy }

      before do
        allow(object).to receive(:mirrors).and_return([])
      end

      it 'returns disabled input' do
        expect(language_input_tag).to include('input').and include('disabled="disabled"')
      end
    end
  end

  describe '#language_label_tag' do
    subject(:language_label_tag) { presenter.language_label_tag(language) }
    let(:object) { create(:page) }

    context 'when is same language for current page' do
      let(:language) { object.site.label.to_sym }
      let(:expected_label) do
        %(<label class="toggle__label-heading" for="edit-mode_en">EN</label>)
      end

      it 'returns label for the same language' do
        expect(language_label_tag).to eq(expected_label)
      end
    end

    context 'when mirror exists' do
      let(:language) { :cy }
      let(:mirror) { create(:page, site: create(:site, :welsh)) }
      let(:expected_label) do
        %(<label class="toggle__label-heading" for="edit-mode_cy">CY</label>)
      end

      before do
        expect(object).to receive(:mirrors).and_return([mirror])
      end

      it 'returns label for mirror language' do
        expect(language_label_tag).to eq(expected_label)
      end
    end

    context 'when mirror does not exist' do
      let(:language) { :cy }
      let(:expected_label) do
        %(<label class="toggle__label-heading" for="edit-mode_cy">CY)
      end

      let(:missing_icon) do
        %(<span class="icon-warning fa fa-warning"></span>)
      end

      before do
        expect(object).to receive(:mirrors).and_return([])
      end

      it 'returns label with missing icon' do
        expect(language_label_tag).to include(expected_label).and include(missing_icon)
      end
    end
  end

  describe '#last_update' do
    let(:object) { double(updated_at: Time.new(2014, 8, 1, 14, 45)) }

    it 'returns the author and the created at formated' do
      expect(presenter.last_update).to eq('01/08/2014, 14:45')
    end
  end

  describe '#preview_url' do
    let(:domain) { 'qa.contento.com' }
    let(:object) { double(site: double(label: 'en'), slug: 'investing') }

    before do
      allow(presenter).to receive(:url_scheme).and_return('http://')
    end

    it 'returns the preview domain and site label with the slug' do
      allow(ComfortableMexicanSofa.config).to receive(:preview_domain).and_return(domain)
      expect(presenter.preview_url).to eq('http://qa.contento.com/en/articles/investing/preview')
    end
  end
end
