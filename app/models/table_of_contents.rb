class TableOfContents
  attr_reader :source, :doc

  def initialize(source)
    @source = source
    @doc = Nokogiri::HTML.fragment(source)
  end

  def call
    h1 = doc.css('h1').first

    h1.add_next_sibling(table_of_contents_html)

    doc.to_s
  end

  private

  def table_of_contents_html
    ERB.new(template).result(binding)
  end

  def items
    headings = doc.css('h2').map(&:text)
    ids = doc.css('h2').map { |node| "##{node[:id]}" }

    headings.zip(ids)
  end

  def template
    <<-EOS
      <ul>
        <li>
          <% items.each do |item| %>
            <a href="<%= item.last %>"><%= item.first %></a>
          <% end %>
        </li>
      </ul>
    EOS
  end
end
