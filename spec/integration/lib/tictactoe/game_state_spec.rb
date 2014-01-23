# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'

describe Tictactoe::GameState do

  let(:game_state) { test_game_state('_________') }

  it 'should have certain defaults when a board is set' do
    b = test_board('_________')
    gs = Tictactoe::GameState.new('x', 'o')
    gs.board = b
    gs.over?.should be_false
    gs.unplayed?.should be_true
    gs.winner_exists?.should be_false
    gs.winning_line.should be_nil
    gs.lost?('x').should be_false
    gs.won?('x').should be_false
    gs.lost?('o').should be_false
    gs.won?('o').should be_false
    gs.final_move.should be_nil
    gs.available_moves.should eq b.blank_spaces
  end

  it 'should return a new instance of game_state when a move is made' do
    new_state = game_state.make_move([0, 0])
    new_state.unplayed?.should be_false
    new_state.player_piece.should eq 'o'
    new_state.opponent_piece.should eq 'x'
  end

  it 'should ensure different instances when moves are made' do
    gs = test_game_state 'xo_______'
    gs_1 = gs.make_move([1, 1])
    gs_2 = gs.make_move([2, 2])
    gs_1.should_not be gs_2
    gs_1.available_moves.should_not eq gs_2.available_moves
  end

  it 'should return an array of corner spaces' do
    game_state.corner_spaces.should eq [[0, 0], [0, 2], [2, 0], [2, 2]]
  end

  it 'should report if there is only a single move left' do
    b = test_game_state('xoxoxox__')
    b.final_move.should be_nil
    b.make_move([2, 1]).final_move.should eq [2, 2]
  end

  it 'should report win information for a row victory' do
    %w(xxxo_o___ o__xxx_o_ o__o__xxx).each do |code|
      b = test_game_state code
      b.won?('x').should be_true, "Failed with #{code}"
      b.draw?.should be_false
      b.over?.should be_true
    end
  end

  it 'should report win information for a column victory' do
    %w(x_oxo_x__ _xo_x_ox_ __x_ox_ox).each do |code|
      b = test_game_state code
      b.won?('x').should be_true, "Failed with #{code}"
      b.draw?.should be_false
      b.over?.should be_true
    end
  end

  it 'should report win information for a diagonal victory' do
    b = test_game_state 'xo__xo__x'
    b.won?('x').should be_true
    b.lost?('o').should be_true
    b.draw?.should be_false
    b.over?.should be_true
  end

  it 'should report win information for a reverse diagonal victory' do
    b = test_game_state 'x_o_o_o_x'
    b.won?('o').should be_true
    b.draw?.should be_false
    b.over?.should be_true
  end

  it 'should report a draw state' do
    b = test_game_state 'xoxxxooxo'
    b.winner_exists?.should be_false
    b.draw?.should be_true
    b.over?.should be_true
  end

  it 'should report if someone has won' do
    b = test_game_state 'o_x_x_x_o'
    b.winner_exists?.should be_true
  end

  it 'should have a general win algorithm for arbitrary board size' do
    win_boards = {
      diagonal: 'xooo_x____x____x',
      reverse_diagonal: 'ooox__x__x__x___',
      row: 'ooo_____xxxx____',
      column: '_xooox___x___x__'
    }
    win_boards.each do |name, code|
      b = test_game_state code, 4, 'x', 'o'
      b.won?('x').should be_true
    end
  end

  it 'should return a list of the winning coordinates for a row win' do
    b = test_game_state 'o__xxx_o_'
    b.winning_line.should eq [[1, 0], [1, 1], [1, 2]]
  end

  it 'should return a list of the winning coordinates for a column win' do
    b = test_game_state '__x_ox_ox'
    b.winning_line.should eq [[0, 2], [1, 2], [2, 2]]
  end

  it 'should return a list of the winning coordinates for a diagonal win' do
    b = test_game_state 'xo__xo__x'
    b.winning_line.should eq [[0, 0], [1, 1], [2, 2]]
  end

  it 'should return a list of the winning coordinates for a diagonal win' do
    b = test_game_state 'x_o_o_o_x'
    b.winning_line.should eq [[0, 2], [1, 1], [2, 0]]
  end

  it 'should return the winning piece' do
    b = test_game_state 'x_o_o_o_x'
    b.winner.should eq 'o'
  end
end
