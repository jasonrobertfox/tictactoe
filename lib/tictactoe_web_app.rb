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
  namespace '/api/v1', layout: false do

    post '/play' do
      begin
        content_type :json
        content = JSON.parse request.body.read
        validate_request content
        game_state = unpack_request content
        validate_gamestate game_state
        computer_payer = Tictactoe::Player::PerfectPlayer.new game_state.player_piece
        new_state = computer_payer.take_turn game_state
        return_success(create_response(new_state))
      rescue ArgumentError => e
        return_fail e.message
      end
    end
  end

  def return_success(data)
    { status: 'success', data: data }.to_json
  end

  def return_fail(message)
    halt 400, { 'Content-Type' => 'application/json' }, { status: 'fail', data: { message: message } }.to_json
  end

  def rows
    %w(top middle bottom)
  end

  def columns
    %w(left center right)
  end

  def validate_request(content)
    return_fail('Piece was not defined as either x or o.') unless content['piece'] && (content['piece'] == 'x' || content['piece'] == 'o')
    return_fail('Board was not defined.') unless content['board']
    return_fail('Board given contains less than 9 spaces.') unless content['board'].count == 9
  end

  def validate_gamestate(game_state)
    return_fail('Nothing to do, the board provided is a draw.') if game_state.is_draw?
    return_fail('Nothing to do, there is already a winner.') if game_state.has_someone_won?
  end

  def unpack_request(content)
    board_array = Array.new(3) { Array.new }
    content['board'].each do |space|
      row_column = space['id'].split('-')
      row = rows.index(row_column.first)
      column = columns.index(row_column.last)
      board_array[row][column] = space['value']
    end
    opponent_piece = content['piece'] == 'x' ? 'o' : 'x'
    Tictactoe::GameState.new(board_array, content['piece'], opponent_piece)
  end

  def create_response(game_state)
    board_data = []
    game_state.board.each_with_index do |row, r|
      row.each_with_index do |value, c|
        board_data.push('id' => "#{rows[r]}-#{columns[c]}", 'value' => value)
      end
    end
    { piece: game_state.player_piece, board: board_data }
  end
end
