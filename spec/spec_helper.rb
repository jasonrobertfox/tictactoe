# Encoding: utf-8

ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'ruby-prof'

def configure_coverage
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter 'spec'
    coverage_dir 'build/coverage'
  end
end

def configure_rspec_defaults
  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run_excluding skip: true
    config.filter_run :focus
    config.order = 'random'
  end
end

def configure_rspec_for_system
  require 'rack/test'
  require 'sinatra'
  require 'capybara/rspec'
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'
  require_relative '../lib/tictactoe_web_app'

  RSpec.configure do |config|
    config.expect_with :rspec, :stdlib
    config.include Rack::Test::Methods
    config.include Capybara::DSL
    def app
      TictactoeWebApp
    end
  end

  Capybara.app = TictactoeWebApp
  Capybara.javascript_driver = :poltergeist
end

def configure_profiling
  RSpec.configure do |config|
    def profile
      result = RubyProf.profile { yield }
      printer = RubyProf::MultiPrinter.new(result)
      name = example.metadata[:full_description].downcase.gsub(/[^a-z0-9_-]/, '-').gsub(/-+/, '-')
      directory_name = 'build/profiles'
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      # printer = RubyProf::CallTreePrinter.new(result)
      printer = RubyProf::DotPrinter.new(result)
      open("#{directory_name}/callgrind.#{name}.#{Time.now.to_i}.dot", 'w') do |f|
        printer.print(f)
      end
    end

    config.around(:each) do |example|
      if example.metadata[:profile] && ENV['PROFILE']
        profile { example.run }
      else
        example.run
      end
    end
  end
end

# Defaults
system = ENV['SYSTEM'] == 'false' ? false : true
coverage = ENV['COVERAGE'] == 'true' ? true : false

# Configuration
configure_coverage if coverage
configure_rspec_defaults
configure_rspec_for_system if system
configure_profiling

# Other general helper functions
def get_adapter
  Tictactoe::Adapter::ThreeSquaredBoardWebAdapter.new('x', 'o')
end

def get_request(piece, data)
  { 'piece' => piece, 'board' => get_test_board_data(data) }
end

def get_test_board_data(data)
  board = []
  rows = %w(top middle bottom)
  columns = %w(left center right)
  r = 0
  c = 0
  data.each do |row|
    row.each do |column|
      id = "#{rows[r]}-#{columns[c]}"
      board.push('id' => id, 'value' => column)
      c == 2 ? c = 0 : c += 1
    end
    r += 1
  end
  board
end

PlayerStub = Struct.new(:piece)

def get_game_state(board, player_piece)
  opponent_piece = player_piece == 'x' ? 'o' : 'x'
  board = make_board(board.flatten.map { |i| i == '' ? '_' : i }.join, 3, player_piece, opponent_piece)
  puts board.inspect
  board
end

# def get_alternative_game_state
#   Tictactoe::GameState.new([['z', ''], ['', 'j']], 'z', 'j')
# end

def get_blank_board
  Array.new(3) { Array.new(3, '') }
end

def build_board(code)
  make_board(code, 3, 'x', 'o')
end

def make_board(code, size, player_piece, opponent_piece)
  puts player_piece
  board = Tictactoe::Board.new(size, player_piece, opponent_piece)
  row = 0
  column = 0
  code.split(//).each do |c|
    board.place_piece(c, row, column) unless c == '_'
    if column == size - 1
      column = 0
      row += 1
    else
      column += 1
    end
  end
  board
end
