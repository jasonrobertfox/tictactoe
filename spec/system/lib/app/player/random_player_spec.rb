# Encoding: utf-8

require 'spec_helper'
require 'app/player/random_player'
require 'app/game_state'

def get_blank_board
  [['', '', ''], ['', '', ''], ['', '', '']]
end
describe App::Player::RandomPlayer do

  it 'should be return a new game stat with a randomly selected move' do
    game_state = App::GameState.new(get_blank_board, 'x')
    player = App::Player::RandomPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.board.flatten.should include 'x'
  end

  it 'should be able to complete a game' do
    game_state = App::GameState.new(get_blank_board, 'x')
    players = { 'x' => App::Player::RandomPlayer.new, 'o' => App::Player::RandomPlayer.new }
    while game_state.over? == false
      game_state = players[game_state.active_turn].get_new_state(game_state)
    end
    game_state.over?.should be_true
  end
  it 'should be able to complete a game' do
    game_state = App::GameState.new([['x', '', ''], ['', '', ''], ['', '', '']], 'o')
    players = { 'x' => App::Player::RandomPlayer.new, 'o' => App::Player::RandomPlayer.new }
    while game_state.over? == false
      game_state = players[game_state.active_turn].get_new_state(game_state)
    end
    game_state.over?.should be_true
  end
end
