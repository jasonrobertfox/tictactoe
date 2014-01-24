# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/board'

describe Tictactoe::Board do

  let(:board) { Tictactoe::Board.new(3) }

  it 'should be initialized with size' do
    board.width.should eq 3
  end

  it 'should report the total spaces' do
    board.number_of_spaces.should eq 9
    board.number_of_blanks.should eq 9
    board.blank_spaces.should eq [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
  end

  it 'should be blank by default' do
    board.blank?.should be_true
  end

  it 'should let a piece be set' do
    board.place_piece('x', [1, 2])
    board.blank_spaces.should eq [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [2, 0], [2, 1], [2, 2]]
    board.number_of_blanks.should eq 8
    board.number_of_occupied.should eq 1
    board.contents_of([1, 2]).should eq 'x'
  end

  it 'should not be blank if a piece has been placed on it' do
    board.place_piece('x', [0, 2])
    board.blank?.should be_false
  end

  it 'should not place blank pieces' do
    board.place_piece(nil, [0, 2])
    board.number_of_blanks.should eq 9
  end

  it 'should return itself after placing a piece' do
    board.place_piece('x', [0, 2]).should be_an_instance_of Tictactoe::Board
  end

  it 'when a board is copied off it should be a deep copy' do
    board.place_piece('x', [0, 0])
    board_copy = board.clone
    board.place_piece('x', [0, 1])
    board_copy.place_piece('x', [0, 2])
    board_copy.contents_of([0, 1]).should be_nil
    board.blank_spaces.should_not eq board_copy.blank_spaces
  end

  it 'should scale available moves for larger boards' do
    b = Tictactoe::Board.new(4)
    b.number_of_spaces.should eq 16
  end

  it 'can be serialized to a flat array' do
    board.place_piece('x', [0, 2])
    board.place_piece('o', [1, 1])
    board.to_a.should eq [nil, nil, 'x', nil, 'o', nil, nil, nil, nil]
  end
end
