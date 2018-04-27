Given(/^I have the category$/) do |table|
  category = build(:category)

  table.rows.each do |row|
    category.send("#{row[0]}=", row[1])
  end

  category.save!
end

Given(/^I have the page$/) do |table|
  page = build(:page)

  page_data = table.rows.to_h.symbolize_keys

  page_data.except(:content, :page_type).each do |attribute, value|
    page.send("#{attribute}=", value)
  end

  page.layout = build(:layout, identifier: page_data[:page_type])

  page.blocks << Comfy::Cms::Block.new(
    identifier: 'content',
    content: page_data[:content],
    processed_content: page_data[:content]
  )

  page.save!
end
