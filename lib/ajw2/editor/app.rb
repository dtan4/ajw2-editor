require "sinatra/base"
require "sinatra/reloader"
require "slim"

module Ajw2::Editor
  class App < Sinatra::Base
    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'app'))
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
