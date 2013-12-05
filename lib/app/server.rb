# Encoding: utf-8

require 'slim'
require 'sinatra'
require 'compass'
require 'sinatra/config_file'
require 'sinatra/namespace'
require 'sinatra/assetpack'
require 'zurb-foundation'
require 'json'

module App
  class Server < Sinatra::Base
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
        '/js/foundation/foundation.js',
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

    namespace '/api/v1', layout: false do

      post '/play' do
        content_type :json
        content = JSON.parse request.body.read
        return_fail('Piece was not defined as either x or o.') unless content['piece'] && (content['piece'] == 'x' || content['piece'] == 'o')
        return_fail('Board was not defined.') unless content['board']
        return_fail('Board given contains less than 9 spaces.') unless content['board'].count == 9
        board = content['board']

        # Here is where we will simply do a random selection again to bring the ui logic onto the server side
        blanks = board.select { |space| space['value'] == '' }
        choice = blanks.sample['id']
        board.each do |space|
          space['value'] = content['piece'] if space['id'] == choice
        end

        # Return the response
        piece = content['piece'] == 'x' ? 'o' : 'x'
        return_success(piece: piece, board: board)
      end

    end

    def return_success(data)
      { status: 'success', data: data }.to_json
    end

    def return_fail(message)
      halt 400, { 'Content-Type' => 'application/json' }, { status: 'fail', data: { message: message } }.to_json
    end
  end
end
