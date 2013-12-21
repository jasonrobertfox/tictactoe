# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/player/perfect_player'

describe Tictactoe::Player::PerfectPlayer do
  it 'should respond to take_turn' do
    player = Tictactoe::Player::PerfectPlayer.new('x')
    player.should respond_to :take_turn
  end

  it 'should respond to piece' do
    player = Tictactoe::Player::PerfectPlayer.new('x')
    player.should respond_to :piece
    player.piece.should eq 'x'
  end
end
