RSpec.shared_examples 'controller assigns presented site files' do
  it 'assigns presented files' do
    get_index
    expect(assigns[:files]).to all(be_a(FilePresenter))
  end

  it 'uses the site files as the presented assigned files' do
    get_index
    presented_files = assigns[:files].map(&:object)
    sites_files = sites.map(&:files).flatten
    expect(presented_files).to match_array(sites_files)
  end

  it 'responds success' do
    get_index
    expect(response).to be_success
  end
end
