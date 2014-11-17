Rails.application.routes.draw do
  devise_for :users, class_name: "Comfy::Cms::User"

  resources :word_documents

  scope '/admin' do
    resources :sites do
      resources :pages
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
  comfy_route :cms, :sitemap => false
end
