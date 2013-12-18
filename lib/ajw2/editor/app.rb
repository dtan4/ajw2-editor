require "sinatra/base"
require "rack/csrf"
require "slim"
require "sass"
require "coffee-script"
require "json"

module Ajw2::Editor
  class App < Sinatra::Base
    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'app'))
      use Rack::Session::Cookie, secret: "ajw2editor"
      use Rack::Csrf, raise: true
    end

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
      Slim::Engine.default_options[:pretty] = true
    end

    helpers do
      def csrf_meta_tag
        Rack::Csrf.csrf_metatag(env)
      end
    end

    get "/" do
      slim :index
    end

    get "/js/app.js" do
      coffee :app
    end

    get "/css/app.css" do
      sass :app
    end

    post "/download" do
      content_type :json

      params = JSON.parse(request.env["rack.input"].read)
      params.to_json
    end
  end
end
