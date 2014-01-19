require "json"
require "ajw2"
require "tempfile"
require "securerandom"

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

  get "/download" do
    if params[:id]
      content_type "text/plain"

      application_id = params[:id]
      attachment "application.txt"

      application_id
    else
      halt 400, "<h1>Invalid arguments</h1>"
    end
  end

  post "/download" do
    begin
      content_type :json

      source = JSON.parse(request.env["rack.input"].read, symbolize_keys: true)
      generator = Ajw2::Generator.new(source[:application], source[:interface], source[:database], source[:event])
      application_id = SecureRandom.hex[0..9]
      # out_dir = Dir.tmpdir
      # generator.generate(out_dir)

      { status: true, id: application_id }.to_json
    rescue ArgumentError => e
      { status: false, message: e.message }.to_json
    end
  end
end
