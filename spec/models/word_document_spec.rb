describe WordDocument do
  subject { WordDocument.new(file) }

  describe '#to_s' do
    context 'structured doc' do
      let(:file) { File.new(Rails.root.join('spec/fixtures/structured_doc.docx')) }
      it 'is converted to structured markdown' do
#         pending

#         expect(subject.to_s.strip).to eql(%q{# Heading One

# The first paragraph summarises the main points of the article in no more than five sentences giving the reader a chance to decide whether to continue reading or not.

# ## Heading Two

# This is a normal paragraph with bullet points from the [Government Digital Service](http://www.gds.gov.uk) [Content Style Guide](https://www.gov.uk/design-principles/style-guide) on writing content that's understandable, concise and relevant, it should be:

# - specific
# - informative
# - clear and concise
# - brisk but not terse
# - incisive
# - serious but not pompous
# - emotionless

# ### Heading Three

# _Plain English is good_; it's a way of writing. Don't use formal or long words when easy or short ones will do. Use "buy" instead of "purchase", "help" instead of "assist", "about" instead of "approximately" and "like" instead of "such as". We can do without these words:

# 1. agenda (unless it's a meeting)
# 2. advancing
# 3. collaborate (use 'working with')
# 4. combating
# 5. deliver (pizzas, post and services are delivered – not abstract concepts like "improvements" or "priorities")

# | **City** | **Population** | **Nickname** |
# | --- | --- | --- |
# | **London** | 8,308,369 | Londongrad |
# | **Edinburgh** | 495,360 | Deadinburgh |
# | **Manchester** | 514,417 | Cottonopolis |})
      end
    end
  end
end