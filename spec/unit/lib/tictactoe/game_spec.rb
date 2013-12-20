# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game'

describe Tictactoe::Game do
  it 'should be initialized with size and pieces' do
    game = Tictactoe::Game.new(3, 'x', 'o')
    game.board_size.should eq 3
    game.first_player.should eq 'x'
    game.second_player.should eq 'o'
  end

  it 'should reject anything but single characters for pieces' do
    expect do
      Tictactoe::Game.new(3, 'XX', 'o')
    end.to raise_error ArgumentError, 'Piece XX must be a single character.'
  end

  it 'should reject pieces that are not different' do
    expect do
      Tictactoe::Game.new(3, 'O', 'o')
    end.to raise_error ArgumentError, 'You can not have both pieces be the same character.'
  end
end
