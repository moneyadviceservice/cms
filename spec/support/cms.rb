RSpec.shared_context 'cms' do
  let!(:site) { Comfy::Cms::Site.create(identifier: 'test') }
  let!(:layout) { site.layouts.create(identifier: identifier, content: '{{ cms:page:content:rich_text }}') }
  let!(:root) { site.pages.new(layout: layout, label: 'root') }
  let!(:page) { site.pages.create(parent: root, layout: layout, label: identifier, slug: identifier.downcase) }

  def identifier
    [*('A'..'Z')].sample(8).join
  end
end
