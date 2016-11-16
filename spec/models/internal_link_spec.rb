describe InternalLink do
  describe '.call' do
    let(:locale) { 'en' }
    subject { InternalLink.new(locale, source).call }

    context 'when internal links menu is missing' do
      let(:source) { s = <<EOF
<h1>Page Title</h1>
<p>some description</p>
<h2>Section 1, and this</h2>
<p>some text</p>
<h2>Do you have Section 2?</h2>
<p>some text</p>
<h2>Section 3</h2>
<p>some text</p>
EOF
        s
      }

      let(:generated_output) { s=<<EOF
<h1>Page Title</h1>
<p>some description</p>
<ul>
<li><a href="#section-1-and-this">Section 1, and this</a></li>
<li><a href="#do-you-have-section-2">Do you have Section 2?</a></li>
<li><a href="#section-3">Section 3</a></li>
</ul>
<h2 id="section-1-and-this">Section 1, and this</h2>
<p>some text</p>
<h2 id="do-you-have-section-2">Do you have Section 2?</h2>
<p>some text</p>
<h2 id="section-3">Section 3</h2>
<p>some text</p>
EOF
        s
      }

      it 'generates internal links menu' do
        expect(subject).to eq generated_output
      end
    end

    context 'when internal links menu was manually entered' do
      let(:source) { s=<<EOF
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
      }

      it 'does nothing' do
        expect(subject).to eq source
      end
    end
  end
end
