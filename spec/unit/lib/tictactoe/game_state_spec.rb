# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'

describe Tictactoe::GameState do

  it 'should be instantiated with the player and opponent pieces' do
    b = Tictactoe::GameState.new('x', 'o')
    b.should be_an_instance_of Tictactoe::GameState
    b.player_piece.should eq 'x'
    b.opponent_piece.should eq 'o'
  end

  it 'should reject anything but single characters for pieces' do
    [%w(XX o), %w(x OO), ['x', ''], ['', 'o']].each do |arguments|
      expect do
        Tictactoe::GameState.new(arguments.first, arguments.last)
      end.to raise_error(ArgumentError, /Pieces must be a single character:/), "Arguments: #{arguments.inspect}"
    end
  end

  it 'should reject pieces that are the same regardless of case' do
    [%w(x x), %w(X x)].each do |arguments|
      expect do
        Tictactoe::GameState.new(arguments.first, arguments.last)
      end.to raise_error(ArgumentError, /Pieces must not be the same:/), "Arguments: #{arguments.inspect}"
    end
  end

  it 'trying to get an unset board should raise an error' do
    gs = Tictactoe::GameState.new('x', 'o')
    expect { gs.board }.to raise_error(RuntimeError, 'Game state has know knowledge of a board.')
  end

  # it 'should be instantiated with an instance of a board' do
  #   board = double 'Tictactoe::Board'
  #   Tictactoe::GameState.new(board, 'x', 'o')
  # end

  # let(:game_state) { Tictactoe::GameState.new(3, 'x', 'o') }

  #   it 'should reject anything but single characters for pieces' do
  #   expect do
  #     Tictactoe::GameStateFactory.build(3, 'XX', 'o')
  #   end.to raise_error ArgumentError, 'Piece XX must be a single character.'
  # end

  # it 'should reject pieces that are not different regardless of case' do
  #   expect do
  #     Tictactoe::GameStateFactory.build(3, 'O', 'o')
  #   end.to raise_error ArgumentError, 'You can not have both pieces be the same character.'
  # end

  # it 'should be initialized with it size' do
  #   game_state.number_of_spaces.should eq 9
  # end

  # it 'should let a piece be set' do
  #   game_state.place_piece('x', [0, 2])
  #   game_state.available_moves.should_not include [0, 2]
  # end

  # it 'should not place blank pieces' do
  #   game_state.place_piece('', [0, 2])
  #   game_state.available_moves.count.should eq 9
  # end

  # it 'should return a full array of available moves' do
  #   game_state.available_moves.should eq [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
  #   game_state.blank?.should be_true
  # end

  # it 'should return an array of corner spaces' do
  #   game_state.corner_spaces.should eq [[0, 0], [0, 2], [2, 0], [2, 2]]
  # end

  # it 'should not be blank if a piece has been placed on it' do
  #   game_state.place_piece('x', [0, 2])
  #   game_state.blank?.should be_false
  # end

  # it 'should return itself after placing a piece' do
  #   game_state.place_piece('x', [0, 2]).should be_an_instance_of Tictactoe::GameState
  # end

  # it 'should not show a move that has been made' do
  #   game_state.place_piece('x', [0, 0])
  #   game_state.available_moves.should eq [[0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
  # end

  # it 'should report if there is only a single move left' do
  #   b = test_game_state('xoxoxox__')
  #   b.last_move?.should be_false
  #   b.place_piece('x', [2, 1])
  #   b.last_move?.should be_true
  # end

  # it 'should report win information for a row victory' do
  #   %w(xxxo_o___ o__xxx_o_ o__o__xxx).each do |code|
  #     b = test_game_state code
  #     b.won?('x').should be_true, "Failed with #{code}"
  #     b.draw?.should be_false
  #     b.over?.should be_true
  #   end
  # end

  # it 'should report win information for a column victory' do
  #   %w(x_oxo_x__ _xo_x_ox_ __x_ox_ox).each do |code|
  #     b = test_game_state code
  #     b.won?('x').should be_true, "Failed with #{code}"
  #     b.draw?.should be_false
  #     b.over?.should be_true
  #   end
  # end

  # it 'should report win information for a diagonal victory' do
  #   b = test_game_state 'xo__xo__x'
  #   b.won?('x').should be_true
  #   b.lost?('o').should be_true
  #   b.draw?.should be_false
  #   b.over?.should be_true
  # end

  # it 'should report win information for a reverse diagonal victory' do
  #   b = test_game_state 'x_o_o_o_x'
  #   b.won?('o').should be_true
  #   b.draw?.should be_false
  #   b.over?.should be_true
  # end

  # it 'should report a draw state' do
  #   b = test_game_state 'xoxxxooxo'
  #   b.winner_exists?.should be_false
  #   b.draw?.should be_true
  #   b.over?.should be_true
  # end

  # it 'should report if someone has won' do
  #   b = test_game_state 'o_x_x_x_o'
  #   b.winner_exists?.should be_true
  # end

  # it 'should scale available moves for larger boards' do
  #   b = Tictactoe::GameState.new(4, 'x', 'o')
  #   b.available_moves.count.should eq 16
  # end

  # it 'should have a general win algorithm for arbitrary board size' do
  #   win_boards = {
  #     diagonal: 'xooo_x____x____x',
  #     reverse_diagonal: 'ooox__x__x__x___',
  #     row: 'ooo_____xxxx____',
  #     column: '_xooox___x___x__'
  #   }
  #   win_boards.each do |name, code|
  #     b = test_game_state code, 4, 'x', 'o'
  #     b.won?('x').should be_true
  #   end
  # end

  # it 'should swap player pieces when the board is handed off' do
  #   b = test_game_state 'xo_______'
  #   b.player_piece.should eq 'x'
  #   b.place_piece('x', [1, 1])
  #   new_b = b.hand_off
  #   new_b.player_piece.should eq 'o'
  #   new_b.opponent_piece.should eq 'x'
  # end

  # it 'when a board is handed off it should be a deep copy' do
  #   b = test_game_state 'xo_______'
  #   b1 = b.hand_off
  #   b2 = b.hand_off
  #   b1.place_piece('x', [1, 1])
  #   b2.place_piece('x', [2, 2])
  #   b2.board[1][1].should eq ''
  #   b1.available_moves.should_not eq b2.available_moves
  # end

  # it 'should return nil for a board with no winning pieces' do
  #   b = test_game_state 'xo_______'
  #   b.winning_line.should be_nil
  # end

  # it 'should return a list of the winning coordinates for a row win' do
  #   b = test_game_state 'o__xxx_o_'
  #   b.winning_line.should eq [[1, 0], [1, 1], [1, 2]]
  # end

  # it 'should return a list of the winning coordinates for a column win' do
  #   b = test_game_state '__x_ox_ox'
  #   b.winning_line.should eq [[0, 2], [1, 2], [2, 2]]
  # end

  # it 'should return a list of the winning coordinates for a diagonal win' do
  #   b = test_game_state 'xo__xo__x'
  #   b.winning_line.should eq [[0, 0], [1, 1], [2, 2]]
  # end

  # it 'should return a list of the winning coordinates for a diagonal win' do
  #   b = test_game_state 'x_o_o_o_x'
  #   b.winning_line.should eq [[0, 2], [1, 1], [2, 0]]
  # end

  # it 'should return the winning piece' do
  #   b = test_game_state 'x_o_o_o_x'
  #   b.winner.should eq 'o'
  # end
end
