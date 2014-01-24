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
end
