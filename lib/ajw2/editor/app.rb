require "sinatra/base"
require "sinatra/reloader"
require "slim"
require "sass"
require "coffee-script"

module Ajw2::Editor
  class App < Sinatra::Base
    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'app'))
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

    get "/css/app.css" do
      sass :app
    end
  end
end
