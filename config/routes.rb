Rails.application.routes.draw do
  devise_for :users, class_name: "Comfy::Cms::User"

  resources :word_documents

  scope '/admin' do
    resources :links, only: :show

    resources :sites do
      resources :files

      resources :pages do
        resources :notes, only: :create
      end

      resources :layouts
      resources :snippets

      namespace 'links' do
        resources :files, only: :index
        resources :pages, only: :index
      end
    end

    resources :tags, only: [:index, :create] do
      collection do
        get    :starting_by
        delete :delete_from_value
      end
    end
    resources :users
  end

  get '/version', to: 'versions#show'
  get '/styleguide', to: 'styleguide#index'

  root to: redirect('/admin')

  comfy_route :cms_admin, :path => '/admin'

  # Make sure this routeset is defined last

  get '/preview(/*cms_path)(.:format)' => 'content#preview', as: "preview_content"
  get '/(*cms_path)(.:format)' => 'content#show', as: "content"
  comfy_route :cms, :sitemap => false
end
