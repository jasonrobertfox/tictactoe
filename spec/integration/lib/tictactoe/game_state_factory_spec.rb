# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state_factory'

describe Tictactoe::GameStateFactory do

  it 'should build a valid game_state from valid arguments' do
    game_state = Tictactoe::GameStateFactory.build(4, 'd', 'j')
    game_state.available_moves.count.should eq 16
    game_state.player_piece.should eq 'd'
    game_state.opponent_piece.should eq 'j'
  end
end
