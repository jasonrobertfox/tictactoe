# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state_factory'

describe Tictactoe::GameStateFactory do

  it 'should reject anything but single characters for pieces' do
    expect do
      Tictactoe::GameStateFactory.build(3, 'XX', 'o')
    end.to raise_error ArgumentError, 'Piece XX must be a single character.'
  end

  it 'should reject pieces that are not different regardless of case' do
    expect do
      Tictactoe::GameStateFactory.build(3, 'O', 'o')
    end.to raise_error ArgumentError, 'You can not have both pieces be the same character.'
  end
end
