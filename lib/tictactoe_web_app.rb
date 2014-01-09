# Encoding: utf-8

# add the /lib directory to the load path
$LOAD_PATH.push File.dirname(__FILE__)

require 'slim'
require 'sinatra'
require 'compass'
require 'sinatra/config_file'
require 'sinatra/namespace'
require 'sinatra/assetpack'
require 'zurb-foundation'
require 'json'

require 'tictactoe/adapter/three_squared_board_web_adapter'

class TictactoeWebApp < Sinatra::Base
  set :root, File.expand_path(File.join(Dir.pwd, 'lib'))

  register Sinatra::ConfigFile
  register Sinatra::Namespace
  register Sinatra::AssetPack

  # Configuration
  config_file 'config/config.yml'

  Compass.configuration do |c|
    c.project_path     = root
    c.sass_dir = 'assets/stylesheets'
    c.images_dir       = 'assets/images'
    c.http_generated_images_path = '/img'
    c.add_import_path  'assets/stylesheets'
  end

  set :scss, Compass.sass_engine_options

  # Assets
  assets do
    serve '/js', from: 'assets/javascripts'
    serve '/css', from: 'assets/stylesheets'
    serve '/img', from: 'assets/images'

    # Javascript placed before the closing <head> tag
    js :head, [
      '/js/vendor/custom.modernizr.js',
      '/js/head.js'
    ]

    # Javascript placed before the closing <body> tag
    js :tail, [
      '/js/Player.js',
      '/js/Board.js',
      '/js/Reporter.js',
      '/js/tail.js'
    ]

    css :app, [
      '/css/app.css'
    ]

    js_compression  :jsmin
    css_compression :sass
    prebuild true if ENV['RACK_ENV'] == 'production'
  end

  get '/' do
    slim :index
  end

  # This API conforms to message specifications as defined by http://labs.omniti.com/labs/jsend
  namespace '/api/v2', layout: false do

    post '/play' do
      begin
        content_type :json
        content = JSON.parse request.body.read
        web_adapter = Tictactoe::Adapter::ThreeSquaredBoardWebAdapter.new
        return_success web_adapter.get_response(content)
      rescue ArgumentError => error
        return_fail error.message
      end
    end
  end

  def return_success(data)
    { status: 'success', data: data }.to_json
  end

  def return_fail(message)
    halt 400, { 'Content-Type' => 'application/json' }, { status: 'fail', data: { message: message } }.to_json
  end
end
