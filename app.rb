require "json"
require "ajw2"
require "pathname"
require "tempfile"
require "securerandom"
require "zip"
require "bootstrap-sass"

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
    sprockets.append_path Bootstrap.stylesheets_path
    sprockets.append_path Bootstrap.fonts_path
    sprockets.append_path Bootstrap.javascripts_path

    set :tempdir, Dir.tmpdir
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

    def symbolize_keys(arg)
      if arg.is_a? Hash
        arg.inject({}) do |result, (k, v)|
          result[k.to_sym] = symbolize_keys(v)
          result
        end
      elsif arg.is_a? Array
        arg.map { |v| symbolize_keys(v) }
      else
        arg
      end
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
    if params[:id] && params[:name]
      content_type "application/zip"

      application_id = params[:id]
      application_name = params[:name]
      attachment "#{application_name}.zip"

      open(File.join(settings.tempdir, "#{application_id}.zip")).read
    else
      halt 400, "<h1>Invalid arguments</h1>"
    end
  end

  post "/download" do
    content_type :json

    begin
      source = symbolize_keys(JSON.parse(request.env["rack.input"].read))
    rescue => e
      halt 400, { message: e.message }.to_json
    end

    begin
      application = Ajw2::Model::Application.new(source[:application])
      interface = Ajw2::Model::Interface.new(source[:interface])
      database = Ajw2::Model::Database.new(source[:database])
      event = Ajw2::Model::Event.new({ events: [] }) # TODO: implement interface for Event
      generator = Ajw2::Generator.new(application, interface, database, event)

      application_id = SecureRandom.hex[0..9]
      application_name = source[:application][:name]
      out_dir = File.join(settings.tempdir, application_id)
      generator.generate(File.join(out_dir, application_name), "") # TODO: take external_file_dir

      zippath = File.join(settings.tempdir, "#{application_id}.zip")

      Zip::File.open(zippath, Zip::File::CREATE) do |zip|
        Dir[File.join(out_dir, "**", "**")].each do |file|
          zip.add(file.sub(File.join(out_dir, ""), ""), file)
        end
      end
    rescue => e
      halt 500, { message: e.message, source: source }.to_json
    end

    { id: application_id, name: application_name }.to_json
  end
end
