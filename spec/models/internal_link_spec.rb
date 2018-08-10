describe InternalLink do
  let(:locale) { 'en' }
  subject { InternalLink.new(locale, source).call }

  describe '.call' do
    context 'when internal links menu is missing' do
      let(:source) do
        s = <<~EOF
          <h1>Page Title</h1>
          <p>some description</p>
          <h2>Section 1, and this</h2>
          <p>some text</p>
          <h2>Do you have Section 2?</h2>
          <p>some text</p>
          <h2>Tip 1 – Section 3</h2>
          <p>some text</p>
        EOF
        s
      end

      let(:generated_output) do
        s = <<~EOF
          <h1>Page Title</h1>
          <p>some description</p>
          <ul>
          <li><a href="#section-1-and-this">Section 1, and this</a></li>
          <li><a href="#do-you-have-section-2">Do you have Section 2?</a></li>
          <li><a href="#tip-1--section-3">Tip 1 – Section 3</a></li>
          </ul>
          <h2 id="section-1-and-this">Section 1, and this</h2>
          <p>some text</p>
          <h2 id="do-you-have-section-2">Do you have Section 2?</h2>
          <p>some text</p>
          <h2 id="tip-1--section-3">Tip 1 – Section 3</h2>
          <p>some text</p>
        EOF
        s
      end

      it 'generates internal links menu' do
        expect(subject).to eq generated_output
      end
    end

    context 'when internal links menu was manually entered' do
      let(:source) do
        s = <<~EOF
          <h1>Page Title</h1>
          <p>some description</p>
          <ul>
          <li><a href="#section-1-and-this">Section 1, and this</a></li>
          <li><a href="#section-2">Section 2</a></li>
          <li><a href="#section-3">Section 3</a></li>
          </ul>
          <h2 id="section-1-and-this">Section 1, and this</h2>
          <p>some text</p>
          <h2 id="section-2">Section 2</h2>
          <p>some text</p>
          <h2 id="section-3">Section 3</h2>
          <p>some text</p>
        EOF
        s
      end

      it 'does nothing' do
        expect(subject).to eq source
      end
    end
  end

  describe 'Punctuation marks' do
    context 'are removed in tag id' do
      let(:source) do
        s = <<~EOF
          <h1>Page Title</h1>
          <p>some description</p>
          <h2>'Section 1', and this</h2>
          <p>some text</p>
          <h2>(Section 2) [brackets]</h2>
          <p>some text</p>
          <h2>{Section 3} "double quotes"</h2>
          <p>some text</p>
        EOF
        s
      end

      let(:generated_output) do
        s = <<~EOF
          <h1>Page Title</h1>
          <p>some description</p>
          <ul>
          <li><a href="#section-1-and-this">'Section 1', and this</a></li>
          <li><a href="#section-2-brackets">(Section 2) [brackets]</a></li>
          <li><a href="#section-3-double-quotes">{Section 3} "double quotes"</a></li>
          </ul>
          <h2 id="section-1-and-this">'Section 1', and this</h2>
          <p>some text</p>
          <h2 id="section-2-brackets">(Section 2) [brackets]</h2>
          <p>some text</p>
          <h2 id="section-3-double-quotes">{Section 3} "double quotes"</h2>
          <p>some text</p>
        EOF
        s
      end
      it 'does nothing' do
        expect(subject).to eq generated_output
      end
    end
  end
end
