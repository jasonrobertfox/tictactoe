# Encoding: utf-8

require 'spec_helper'
require 'app/game_state'
require 'app/player/perfect_player'

describe App::Player::PerfectPlayer do

  it 'should simply fill in the last space if there is only one blank' do
    game_state = App::GameState.new([['', 'o', 'x'], %w(o o x), %w(x x o)], 'x')
    player = App::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.draw?.should be_true
  end

  it 'should pick the winning move of a nearly complete game for x' do
    game_state = App::GameState.new([['x', 'o', ''], ['x', 'x', ''], ['', 'o', 'o']], 'x')
    player = App::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 2
    new_state.win?('x').should be_true
  end

  it 'should pick the winning move of a nearly complete game for o' do
    game_state = App::GameState.new([%w(x o x), ['x', 'x', ''], ['', 'o', 'o']], 'o')
    player = App::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.win?('o').should be_true
  end

  it 'should pick the winning move from a more incomplete game' do
    game_state = App::GameState.new([['x', '', 'x'], ['', 'o', ''], ['', 'o', '']], 'x')
    player = App::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.win?('x').should be_true
  end

  it 'should pick the next move from a more incomplete game' do
    game_state = App::GameState.new([['x', '', ''], ['', '', ''], ['', '', '']], 'o')
    player = App::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 7
    new_state.over?.should be_false
  end
end
