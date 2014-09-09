Rails.application.routes.draw do
  resources :word_documents

  get '/version', to: 'versions#show'
  get '/frontend', to: 'frontend#index'

  root to: redirect('/admin')

  comfy_route :cms_admin, :path => '/admin'

  # Make sure this routeset is defined last
  comfy_route :cms, :sitemap => false
end
