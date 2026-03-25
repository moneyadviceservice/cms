class HomeController < ActionController::Base
  def index
    render text: 'This service is API only. Contact ben.lovell@maps.org.uk', layout: false
  end
end
