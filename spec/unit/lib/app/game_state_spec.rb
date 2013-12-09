# Encoding: utf-8

require 'spec_helper'
require 'app/game_state'

def get_draw_board
  get_test_board_data([%w(x x o), %w(o o x), %w(x o x)])
end

def get_in_progress_board
  get_test_board_data([['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']])
end

def get_x_winning_board
  get_test_board_data([%w(x x x), ['o', 'o', ''], ['', '', '']])
end

def get_o_winning_board
  get_test_board_data([%w(x x o), ['x', 'o', ''], ['o', '', '']])
end

describe App::GameState do
  it 'should be initialized with the board information and the active turn' do
    board = get_in_progress_board
    active_turn = 'x'
    game_state = App::GameState.new(board, active_turn)
    game_state.board.should eq board
    game_state.active_turn.should eq active_turn
    game_state.board_array.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
  end

  it 'should report if the game state is over' do
    game_state = App::GameState.new(get_draw_board, 'o')
    game_state.over?.should be_true
    game_state = App::GameState.new(get_in_progress_board, 'x')
    game_state.over?.should be_false
  end

  it 'should report if the game has been won' do
    game_state = App::GameState.new(get_x_winning_board, 'o')
    game_state.win?.should be_true
    game_state.win?('x').should be_true
    game_state.win?('o').should be_false
    game_state.over?.should be_true
    game_state = App::GameState.new(get_o_winning_board, 'x')
    game_state.win?.should be_true
    game_state.win?('x').should be_false
    game_state.win?('o').should be_true
    game_state.over?.should be_true
  end

  it 'should report if the game is a draw' do
    game_state = App::GameState.new(get_draw_board, 'o')
    game_state.draw?.should be_true
    game_state.over?.should be_true
  end

end
