Rails.application.routes.draw do
  get '/version', to: 'versions#show'

  comfy_route :cms_admin, :path => '/cms'

  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false
end
