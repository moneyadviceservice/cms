describe Cms::LayoutField do
  subject(:layout_field) do
    described_class.new(comfortable_mexican_sofa_tag)
  end

  describe '#input_tag_for' do
    let(:input_tag_for) do
      layout_field.input_tag_for(form_builder: form_builder, index: 0)
    end

    context 'when comfortable mexican sofa tag is rich text' do
      let(:comfortable_mexican_sofa_tag) do
        ComfortableMexicanSofa::Tag::PageRichText.new
      end
      let(:form_builder) { double }

      it 'renders page rich text input tag from the form builder' do
        expect(form_builder).to receive(:page_rich_text)
          .with(comfortable_mexican_sofa_tag, 0)

        input_tag_for
      end
    end
  end
end
