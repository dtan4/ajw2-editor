require "sinatra/base"
require "sinatra/reloader"
require "slim"
require "coffee-script"
require "thin"

module Ajw2::Editor
  class App < Sinatra::Base
    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'app'))
      set :server, "thin"
      Slim::Engine.default_options[:pretty] = true
    end

    configure :development do
      Bundler.require :development
      register Sinatra::Reloader
    end

    get "/" do
      slim :index
    end

    get "/js/app.js" do
      coffee :app
    end
  end
end
