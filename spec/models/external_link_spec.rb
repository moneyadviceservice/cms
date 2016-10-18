describe ExternalLink do
  describe '.call' do
    subject { ExternalLink.new(source).call }

    context 'when link tag has target _blank' do
      let(:source) { '<a href="#test" target="_blank">hello</a>' }
      let(:appended_link) { '<a href="#test" target="_blank">hello</a><span class="visually-hidden">open in a tab</span>' }

      it 'append visually hidden tag' do
        expect(subject).to eql appended_link
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
