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

  it 'can be created with formated data' do
    game_state = App::GameState.new_from_data(get_in_progress_board, 'x')
    game_state.board.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
  end

  it 'can be created with an array' do
    board = [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
    game_state = App::GameState.new(board, 'x')
    game_state.board.should eq board
  end

  it 'can output formatted data' do
    board = [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
    game_state = App::GameState.new(board, 'x')
    game_state.get_data.should eq get_in_progress_board
  end

  it 'should be initialized with the board information and the active turn' do
    game_state = App::GameState.new_from_data(get_in_progress_board, 'x')
    game_state.board.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
    game_state.active_turn.should eq 'x'
  end

  it 'should report if the game state is over' do
    game_state = App::GameState.new_from_data(get_draw_board, 'o')
    game_state.over?.should be_true
    game_state = App::GameState.new_from_data(get_in_progress_board, 'x')
    game_state.over?.should be_false
  end

  it 'should report if the game has been won' do
    game_state = App::GameState.new_from_data(get_x_winning_board, 'o')
    game_state.win?.should be_true
    game_state.win?('x').should be_true
    game_state.win?('o').should be_false
    game_state.over?.should be_true
    game_state = App::GameState.new_from_data(get_o_winning_board, 'x')
    game_state.win?.should be_true
    game_state.win?('x').should be_false
    game_state.win?('o').should be_true
    game_state.over?.should be_true
  end

  it 'should report if the game is a draw' do
    game_state = App::GameState.new_from_data(get_draw_board, 'o')
    game_state.draw?.should be_true
    game_state.over?.should be_true
  end

  it 'should return an array of the blank spaces' do
    game_state = App::GameState.new_from_data(get_in_progress_board, 'x')
    game_state.get_blanks.should eq [[0, 2], [1, 2], [2, 2]]
  end

  it 'should return a new instance of itself on update state' do
    game_state = App::GameState.new_from_data(get_in_progress_board, 'x')
    new_state = game_state.get_new_state([0, 2])
    result = [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]
    new_state.board.should eq result
    new_state.active_turn.should eq 'o'
    new_state.should_not be game_state
    game_state.should_not eq result
  end
end
