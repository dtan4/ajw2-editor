require "json"

class App < Sinatra::Base
  set :sprockets, Sprockets::Environment.new

  configure do
    use Rack::Session::Cookie, secret: "ajw2editor"
    use Rack::Csrf, raise: true

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = "/assets"
      config.digest = true
    end

    sprockets.append_path "assets/javascripts"
    sprockets.append_path "assets/stylesheets"
  end

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    Slim::Engine.default_options[:pretty] = true
  end

  helpers Sprockets::Helpers

  helpers do
    def csrf_meta_tag
      Rack::Csrf.csrf_metatag(env)
    end
  end

  get "/" do
    slim :index
  end

  get "/js/main.js" do
    coffee :main
  end

  get "/css/main.css" do
    sass :main
  end

  post "/download" do
    content_type :json

    params = JSON.parse(request.env["rack.input"].read)
    params.to_json
  end
end
