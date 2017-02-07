namespace :page_conversion do
  desc 'Convert all pages from Markdown to HTML'
  task to_html: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.transaction do
      blocks = Comfy::Cms::Block.where(identifier: 'content').includes(:blockable)
      blocks.find_each do |block|
        processed_content = Mastalk::Document.new(block.content).to_html
        block.update(processed_content: processed_content)
      end
    end
  end
end
