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

require 'tictactoe/player/perfect_player'
require 'tictactoe/game_state'

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
  # Simple api version, just as a best practice
  namespace '/api/v1', layout: false do

    post '/play' do
      content_type :json

      # puts request.body.read

      content = JSON.parse request.body.read
      return_fail('Piece was not defined as either x or o.') unless content['piece'] && (content['piece'] == 'x' || content['piece'] == 'o')
      return_fail('Board was not defined.') unless content['board']
      return_fail('Board given contains less than 9 spaces.') unless content['board'].count == 9

      # Check edge cases for silly api requests
      game_state = Tictactoe::GameState.new_from_data(content['board'], content['piece'])
      return_fail('Nothing to do, the board provided is a draw.') if game_state.draw?
      return_fail('Nothing to do, there is already a winner.') if game_state.win?

      # For now we will replace the random logic with a random player
      computer_payer = Tictactoe::Player::PerfectPlayer.new
      new_state = computer_payer.get_new_state(game_state)

      # puts JSON.to_json(piece: new_state.active_turn, board: new_state.get_data)

      return_success(piece: new_state.active_turn, board: new_state.get_data)
    end
  end

  def return_success(data)
    { status: 'success', data: data }.to_json
  end

  def return_fail(message)
    halt 400, { 'Content-Type' => 'application/json' }, { status: 'fail', data: { message: message } }.to_json
  end
end
