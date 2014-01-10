# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/board_factory'

describe Tictactoe::BoardFactory do

  it 'should build a valid board from valid arguments' do
    board = Tictactoe::BoardFactory.build(4, 'd', 'j')
    board.available_moves.count.should eq 16
    board.player_piece.should eq 'd'
    board.opponent_piece.should eq 'j'
  end
end
