class ContentsTable
  attr_reader :source, :doc

  def initialize(source)
    @source = source
    @doc = Nokogiri::HTML.fragment(source)
  end

  def call
    containers.each { |container| container.add_child(table_of_contents_html) }
    doc.to_s
  end

  private

  def containers
    doc.css('.contents-table')
  end

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
        <% items.each do |item| %>
          <li><a href="<%= item.last %>"><%= item.first %></a></li>
        <% end %>
      </ul>
    EOS
  end
end