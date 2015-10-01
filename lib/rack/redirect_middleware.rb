module Rack
  module RedirectMiddleware
    class Responder
      def initialize(app)
        @app = app
      end

      def call(env)
        regex = /\A\/api(\/[^.]*(\.aspx|\.pdf|\.html)?)(\.json)?\z/
        source_path = Array(regex.match(env['PATH_INFO']))[1]

        if source_path && redirect = Redirect.find_by(source: source_path)
          [redirect.status_code, {'Location' => "#{ENV['FARADAY_X_FORWARDED_PROTO']}://#{ENV['FARADAY_HOST']}#{redirect.destination}"}, ['']]
        else
          @app.call(env)
        end
      end
    end
  end
end
