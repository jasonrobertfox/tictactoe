# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'

def get_draw_board
  [%w(x x o), %w(o o x), %w(x o x)]
end

def get_in_progress_board
  [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
end

def get_x_winning_board
  [%w(x x x), ['o', 'o', ''], ['', '', '']]
end

def get_o_winning_board
  [%w(x x o), ['x', 'o', ''], ['o', '', '']]
end

def get_game_state(board, player_piece)
  opponent_piece = player_piece == 'x' ? 'o' : 'x'
  Tictactoe::GameState.new(board, player_piece, opponent_piece)
end

describe Tictactoe::GameState do

   it 'should be initialized with size and pieces' do
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.player_piece.should eq 'x'
    game_state.opponent_piece.should eq 'o'
  end

  it 'should reject anything but single characters for pieces' do
    expect do
      Tictactoe::GameState.new(get_in_progress_board, 'XX', 'o')
    end.to raise_error ArgumentError, 'Piece XX must be a single character.'
  end

  it 'should reject pieces that are not different regardless of case' do
    expect do
      Tictactoe::GameState.new(get_in_progress_board, 'O', 'o')
    end.to raise_error ArgumentError, 'You can not have both pieces be the same character.'
  end

  # TODO: move translation of transport data to different class
  # it 'can be created with formated data' do
  #   game_state = get_game_state(get_in_progress_board, 'x')
  #   game_state.board.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
  # end

  # it 'can be created with an array' do
  #   board = [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
  #   game_state = Tictactoe::GameState.new(board, 'x', 'o')
  #   game_state.board.should eq board
  # end

  # it 'can output formatted data' do
  #   board = [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
  #   game_state = Tictactoe::GameState.new(board, 'x', 'o')
  #   game_state.get_data.should eq get_test_board_data(get_in_progress_board)
  # end

  it 'should be initialized with the board information and the active turn' do
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.board.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
    game_state.active_turn.should eq 'x'
  end

  it 'should report if the game state is over' do
    game_state = get_game_state(get_draw_board, 'o')
    game_state.over?.should be_true
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.over?.should be_false
  end

  it 'should report if the game has been won' do
    game_state = get_game_state(get_x_winning_board, 'o')
    game_state.win?.should be_true
    game_state.win?('x').should be_true
    game_state.win?('o').should be_false
    game_state.over?.should be_true
    game_state = get_game_state(get_o_winning_board, 'x')
    game_state.win?.should be_true
    game_state.win?('x').should be_false
    game_state.win?('o').should be_true
    game_state.over?.should be_true
  end

  it 'should report if the game is a draw' do
    game_state = get_game_state(get_draw_board, 'o')
    game_state.draw?.should be_true
    game_state.over?.should be_true
  end

  it 'should return an array of the blank spaces' do
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.get_blanks.should eq [[0, 2], [1, 2], [2, 2]]
  end

  it 'should return a new instance of itself on update state' do
    game_state = get_game_state(get_in_progress_board, 'x')
    new_state = game_state.get_new_state([0, 2])
    result = [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]
    new_state.board.should eq result
    new_state.active_turn.should eq 'o'
    new_state.should_not be game_state
    game_state.should_not eq result
  end
end
