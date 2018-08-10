describe TableCaptioner do
  context 'when there is no table' do
    let(:source) { '<p>hello</p>' }

    subject do
      described_class.new(double, source)
    end

    it 'does nothing' do
      expect(subject.call).to eql(source)
    end
  end

  context 'when there is a table' do
    context 'and there is a paragraph with class "caption" immediately after it' do
      let(:caption) { 'This is the caption' }
      let(:source) { "<table><tr><td></td></tr></table><p class='caption'>#{caption}</p>" }

      subject do
        described_class.new(double, source)
      end

      it 'removes the paragraph and inserts the contents of it as a caption tag' do
        # Include newlines due to Nokogiri's formatted output
        expected_response = "<table>\n<caption>#{caption}</caption>\n<tr><td></td></tr>\n</table>"
        expect(subject.call).to eql(expected_response)
      end
    end

    context 'and it is followed by paragraph without any particular class' do
      let(:source) { '<table><tr><td></td></tr></table>' }

      subject do
        described_class.new(double, source)
      end

      it 'does not make any changes' do
        expect(subject.call).to eql(source)
      end
    end
  end
end
