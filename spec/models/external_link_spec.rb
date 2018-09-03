describe ExternalLink do
  describe '.call' do
    let(:locale) { 'en' }
    subject { ExternalLink.new(locale, source).call }

    describe 'when link tag has target _blank' do
      let(:source) { '<a href="#test" target="_blank">foo</a>' }

      context 'for english' do
        let(:appended_link) do
          '<a href="#test" target="_blank">foo</a><span class="visually-hidden">opens in new window</span>'
        end

        it 'appends visually hidden tag' do
          is_expected.to eq(appended_link)
        end
      end

      context 'for welsh' do
        let(:locale) { 'cy' }
        let(:appended_link) do
          '<a href="#test" target="_blank">foo</a><span class="visually-hidden">yn agor mewn ffenestr newydd</span>'
        end

        it 'appends visually hidden tag' do
          is_expected.to eq(appended_link)
        end
      end
    end

    context 'when link tag does not have target _blank' do
      let(:source) { '<a href="#test">hello</a>' }

      it 'does nothing' do
        expect(subject).to eql source
      end
    end
  end
end
