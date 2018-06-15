Rails.application.routes.draw do
  apipie
  
  devise_for :users, class_name: 'Comfy::Cms::User'

  resources :word_documents

  scope '/admin' do
    get 'links/(*id)(.:format)' => 'links#show', as: 'admin_link'

    resources :redirects do
      collection do
        get :search
        get :help
      end
    end

    resources :sites do
      resources :files

      resources :pages do
        resources :notes, only: :create
      end

      resources :layouts
      resources :snippets
      resources :page_feedbacks, only: [:index]

      namespace 'links' do
        resources :documents, only: :index
        resources :images, only: :index
        resources :pages, only: :index
      end
    end

    resources :categories do
      collection { put :reorder }
    end

    resources :clumps, except: :destroy do
      collection { put :reorder }
    end

    resources :tags, only: [:index, :create] do
      collection do
        get :starting_by
        delete :delete_from_value
      end
    end

    resources :users
  end

  get '/version', to: 'versions#show'
  get '/styleguide', to: 'styleguide#index'

  root to: redirect('/admin')

  comfy_route :cms_admin, path: '/admin'

  namespace :api do
    scope ":locale", locale: /en|cy/ do
      resources :documents, only: :index
    end

    get '/:locale/thematic_reviews' => 'documents#index'
    get '/:locale/thematic_reviews_landing_pages' => 'documents#index'
    get '/:locale/categories(.:format)' => 'category_contents#index'
    get '/:locale/categories/(*id)(.:format)' => 'category_contents#show'
    get '/preview/:locale/(*slug)(.:format)' => 'content#preview', as: 'preview_content'

    get '/:locale/:page_type/published(.:format)' => 'content#published', defaults: { format: 'json' }
    get '/:locale/:page_type/unpublished(.:format)' => 'content#unpublished', defaults: { format: 'json' }
    get '/:locale/:page_type/(*slug)(.:format)' => 'content#show', as: 'content'
  end

  namespace :api, path: '/' do
    get '/:locale/clumps(.:format)' => 'clumps#index'

    get '/:locale/categories(.:format)' => 'category_contents#index'
    get '/:locale/categories/(*id)(.:format)' => 'category_contents#show'
    get '/preview/:locale/(*slug)(.:format)' => 'content#preview'

    get '/:locale/:page_type/published(.:format)' => 'content#published', defaults: { format: 'json' }
    get '/:locale/:page_type/unpublished(.:format)' => 'content#unpublished', defaults: { format: 'json' }
    get '/:locale/:page_type/(*slug)(.:format)' => 'content#show'

    post '/api/:locale/:slug/page_feedbacks' => 'page_feedbacks#create' if Feature.active?(:page_feedback)
    patch '/api/:locale/:slug/page_feedbacks' => 'page_feedbacks#update' if Feature.active?(:page_feedback)
  end

  # Overwriten comfy route to hit the application.
  get '/(*locale)(.:format)' => 'api/content#show'

  comfy_route :cms, sitemap: false
end
