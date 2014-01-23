# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/player/perfect_player'

describe Tictactoe::Player::PerfectPlayer do
  it 'should respond to take_turn' do
    Tictactoe::Player::PerfectPlayer.new.should respond_to :take_turn
  end
end
