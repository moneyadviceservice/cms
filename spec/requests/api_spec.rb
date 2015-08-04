RSpec.describe "old api endpoint", type: :request do
  let!(:site) { create(:site, path: 'en', locale: 'en', is_mirrored: true) }
  let!(:article_layout) { create(:layout, :article, site: site, identifier: 'article') }
  let!(:article) { create(:page, site: site, layout: article_layout) }

  it "returns the article at /en/articles/article.json" do
    get "/en/articles/#{article.slug}.json"
    expect(JSON.parse(response.body)['full_path']).to eql("/en/articles/#{article.slug}")
  end
end

RSpec.describe "new api endpoint", type: :request do
  let!(:site) { create(:site, path: 'en', locale: 'en', is_mirrored: true) }
  let!(:article_layout) { create(:layout, :article, site: site, identifier: 'article') }
  let!(:article) { create(:page, site: site, layout: article_layout) }

  it "returns the article at /en/articles/article.json" do
    get "/api/en/articles/#{article.slug}.json"
    expect(JSON.parse(response.body)['full_path']).to eql("/en/articles/#{article.slug}")
  end
end
