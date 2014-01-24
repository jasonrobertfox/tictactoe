# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'
require 'tictactoe/player/perfect_player'

describe Tictactoe::Player::PerfectPlayer do

  let(:player) { Tictactoe::Player::PerfectPlayer.new }

  it 'should pick a good opening move if the game_state is blank' do
    game_state = test_game_state('_________')
    new_game_state = player.take_turn(game_state)
    new_game_state.board.to_a.should include 'x'
    new_game_state.player_piece.should eq 'o'
  end

  it 'should simply fill in the last space if there is only one blank' do
    game_state = test_game_state '_oxooxxxo', 3, 'x', 'o'
    new_game_state = player.take_turn(game_state)
    new_game_state.draw?.should be_true
  end

  it 'should pick the winning move of a nearly complete game for x' do
    game_state = test_game_state 'xo_xx__oo', 3, 'x', 'o'
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.count.should eq 2
    new_game_state.won?('x').should be_true
  end

  it 'should pick the winning move of a nearly complete game for o' do
    game_state = test_game_state 'xoxxx__oo', 3, 'o', 'x'
    new_game_state = player.take_turn(game_state)
    new_game_state.won?('o').should be_true
  end

  it 'should pick the winning move from a more incomplete game' do
    game_state = test_game_state('x_x_o__o_', 3, 'x', 'o')
    new_game_state = player.take_turn(game_state)
    new_game_state.won?('x').should be_true
  end

  it 'should pick the next move from a more incomplete game', profile: true do
    game_state = test_game_state('o________', 3, 'x', 'o')
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.length.should eq 7
    new_game_state.over?.should be_false
  end

  it 'should clearly block a move' do
    game_state = test_game_state('____x_x_o', 3, 'o', 'x')
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.length.should eq 5
    new_game_state.over?.should be_false
    new_game_state.available_moves.should_not include [0, 2]
  end

  it 'should clearly block a move 2' do
    game_state = test_game_state('o____x__x', 3, 'o', 'x')
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.length.should eq 5
    new_game_state.over?.should be_false
    new_game_state.available_moves.should_not include [0, 2]
  end

  it 'should clearly block a move 3' do
    game_state = test_game_state('x_o_xx__o', 3, 'o', 'x')
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.should_not include [1, 0]
  end

  it 'should work with an alternative state' do
    game_state = test_game_state('__zj', 2, 'z', 'j')
    new_game_state = player.take_turn(game_state)
    new_game_state.available_moves.should_not include [0, 0]
  end

  it 'should clearly block a move 3' do
    game_state = test_game_state('_x___xoox', 3, 'o', 'x')
    new_game_state = player.take_turn(game_state)
    new_game_state.over?.should be_false
    new_game_state.available_moves.should_not include [0, 2]
  end

  it 'should return the state if the game is already over' do
    game_state = test_game_state 'oo_xxx___', 3, 'o', 'x'
    new_game_state = player.take_turn(game_state)
    new_game_state.should be game_state
  end

  it 'should draw when playing itself' do
    game_state = test_game_state('_________')
    game_state = player.take_turn(game_state) while game_state.over? == false
    game_state.draw?.should be_true
  end

  it 'should always draw when playing itself' do
    results = []
    (1..5).each do
      game_state = test_game_state('_________')
      game_state = player.take_turn(game_state) while game_state.over? == false
      results.push game_state.draw?
    end
    results.should_not include false
  end
end
