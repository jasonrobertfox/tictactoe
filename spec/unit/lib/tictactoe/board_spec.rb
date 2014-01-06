# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/board'

describe Tictactoe::Board do

  let(:board) { Tictactoe::Board.new(3) }

  it 'should be initialized with it size' do
    board.size.should eq 3
  end

  it 'should let a piece be set' do
    board.place_piece('x', 0, 2)
    board.piece_at(0, 2).should eq 'x'
  end

  it 'should return a full array of available moves' do
    board.available_moves.should eq [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
    board.blank?.should be_true
  end

  it 'should return an array of corner spaces' do
    board.corner_spaces.should eq [[0, 0], [0, 2], [2, 0], [2, 2]]
  end

  it 'should not be blank if a piece has been placed on it' do
    board.place_piece('x', 0, 2)
    board.blank?.should be_false
  end

  it 'should not show a move that has been made' do
    board.place_piece('x', 0, 0)
    board.available_moves.should eq [[0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
  end

  it 'should report if there is only a single move left' do
    b = build_board('xoxoxox__')
    b.last_move?.should be_false
    b.place_piece('x', 2, 1)
    b.last_move?.should be_true
  end

  it 'should report win information for a row victory' do
    %w(xxxo_o___ o__xxx_o_ o__o__xxx).each do |code|
      b = build_board code
      b.winner.should eq('x'), "Failed with #{code}"
      b.draw?.should be_false
      b.over?.should be_true
    end
  end

  it 'should report win information for a column victory' do
    %w(x_oxo_x__ _xo_x_ox_ __x_ox_ox).each do |code|
      b = build_board code
      b.winner.should eq('x'), "Failed with #{code}"
      b.draw?.should be_false
      b.over?.should be_true
    end
  end

  it 'should report win information for a diagonal victory' do
    b = build_board 'xo__xo__x'
    b.winner.should eq('x')
    b.draw?.should be_false
    b.over?.should be_true
  end

  it 'should report win information for a reverse diagonal victory' do
    b = build_board 'o_x_x_x_o'
    b.winner.should eq('x')
    b.draw?.should be_false
    b.over?.should be_true
  end


end

def build_board(code)
  board = Tictactoe::Board.new(3)
  row = 0
  column = 0
  code.split(//).each do |c|
    board.place_piece(c, row, column) unless c == '_'
    if column == 2
      column = 0
      row += 1
    else
      column += 1
    end
  end
  board
end
