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

def get_player_stub(piece)
  PlayerStub.new(piece)
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

  it 'should reject a non square board' do
    expect do
      Tictactoe::GameState.new([%w(x o o), ['x', 'o', '']], 'x', 'o')
    end.to raise_error ArgumentError, 'Provided board is not square.'
  end

  it 'should reject a board with invalid pieces' do
    expect do
      Tictactoe::GameState.new([%w(x 1 o), ['x', 'b', ''], ['x', 'o', '']], 'x', 'o')
    end.to raise_error ArgumentError, 'Board contains invalid pieces.'
  end

  it 'should be initialized with the board information and the active turn' do
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.board.should eq [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]
    game_state.player_piece.should eq 'x'
  end

  it 'should report if the game state is over' do
    game_state = get_game_state(get_draw_board, 'o')
    game_state.is_over?.should be_true
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.is_over?.should be_false
  end

  it 'should report if the game has been won' do
    game_state = get_game_state(get_x_winning_board, 'o')
    game_state.has_someone_won?.should be_true
    game_state.have_i_won?('x').should be_true
    game_state.have_i_lost?('x').should be_false
    game_state.is_over?.should be_true
    game_state = get_game_state(get_o_winning_board, 'x')
    game_state.has_someone_won?.should be_true
    game_state.have_i_won?('x').should be_false
    game_state.have_i_lost?('x').should be_true
    game_state.is_over?.should be_true
  end

  it 'should check additional win states' do
    win_boards = {
      diagonal: [['x', 'x', ''], ['o', 'x', ''], %w(x o x)],
      column: [['x', 'x', ''], ['x', 'o', ''], ['x', 'o', '']]
    }
    win_boards.each do |name, board|
      game_state = Tictactoe::GameState.new(board, 'o', 'x')
      game_state.have_i_won?('x').should be_true, "#{name} should have won but it didn't!"
    end
  end

  it 'should report if the game is a draw' do
    game_state = get_game_state(get_draw_board, 'o')
    game_state.is_draw?.should be_true
    game_state.is_over?.should be_true
  end

  it 'should return an array of available moves' do
    game_state = get_game_state(get_in_progress_board, 'x')
    game_state.available_moves.should eq [[0, 2], [1, 2], [2, 2]]
  end

  it 'should indicated if the board is empty' do
    game_state = get_game_state(get_blank_board, 'x')
    game_state.board_empty?.should be_true
  end

  it 'should scale available moves for larger boards' do
    board = Array.new(4) { Array.new(4, '') }
    game_state = get_game_state(board, 'x')
    game_state.available_moves.count.should eq 16
  end

  it 'should return a new instance of itself when a move is applied' do
    game_state = get_game_state(get_in_progress_board, 'x')
    new_state = game_state.apply_move [0, 2]
    result = [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]
    new_state.board.should eq result
    new_state.player_piece.should eq 'o'
    new_state.should_not be game_state
    game_state.should_not eq result
  end

  it 'should have a general win algorithm for arbitrary board size' do
    win_boards = {
      diagonal: [['x', '', '', ''], ['', 'x', '', ''], ['', '', 'x', ''], ['', '', '', 'x']],
      reverse_diagonal: [['', '', '', 'x'], ['', '', 'x', ''], ['', 'x', '', ''], ['x', '', '', '']],
      row: [['', '', '', ''], ['', '', '', ''], %w(x x x x), ['', '', '', '']],
      column: [['', 'x', '', ''], ['', 'x', '', ''], ['', 'x', '', ''], ['', 'x', '', '']]
    }

    win_boards.each do |name, board|
      game_state = Tictactoe::GameState.new(board, 'o', 'x')
      game_state.have_i_won?('x').should be_true, "#{name} should have won but it didn't!"
    end
  end
end
