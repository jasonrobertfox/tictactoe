# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/board'
require 'tictactoe/player/perfect_player'

def get_player(piece)
  Tictactoe::Player::PerfectPlayer.new(piece)
end

describe Tictactoe::Player::PerfectPlayer do

  it 'should reject a game state where it is not the turn taking player' do
    game_state = make_board '_oxooxxxo', 3, 'x', 'o'
    player = get_player 'o'
    expect do
      player.take_turn(game_state)
    end.to raise_error ArgumentError, 'It is not this player\'s turn.'
  end

  it 'should pick a good opening move if the board is blank' do
    game_state = get_game_state(get_blank_board, 'x')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    [new_state.piece_at(0,0), new_state.piece_at(2,0), new_state.piece_at(0,2), new_state.piece_at(2,2)].should include 'x'
    new_state.player_piece.should eq 'o'
  end

  it 'should simply fill in the last space if there is only one blank' do
    game_state = make_board '_oxooxxxo', 3, 'x', 'o'
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.draw?.should be_true
  end

  it 'should pick the winning move of a nearly complete game for x' do
    game_state = make_board 'xo_xx__oo', 3, 'x', 'o'
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.available_moves.count.should eq 2
    new_state.has_won?('x').should be_true
  end

  it 'should pick the winning move of a nearly complete game for o' do
    game_state = make_board 'xoxxx__oo', 3, 'o', 'x'
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.has_won?('o').should be_true
  end

  it 'should pick the winning move from a more incomplete game' do
    game_state = make_board('x_x_o__o_', 3, 'x', 'o')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.has_won?('x').should be_true
  end

  it 'should pick the next move from a more incomplete game', profile: true do
    game_state = make_board('o________', 3, 'x', 'o')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 7
    new_state.over?.should be_false
  end

  it 'should clearly block a move' do
    game_state = make_board('____x_x_o', 3, 'o', 'x')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 5
    new_state.over?.should be_false
    new_state.available_moves.should_not include [0, 2]
  end

  it 'should clearly block a move 2' do
    game_state = make_board('o____x__x', 3, 'o', 'x')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 5
    new_state.over?.should be_false
    new_state.available_moves.should_not include [0, 2]
  end

  it 'should work with an alternative state' do
    game_state = make_board('__zj', 2, 'z', 'j')
    player = get_player 'z'
    new_state = player.take_turn(game_state)
    new_state.available_moves.should_not include [0, 1]
  end

  it 'should clearly block a move 3' do
    game_state = make_board('_x___xoox', 3, 'o', 'x')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.over?.should be_false
    new_state.available_moves.should_not include [0, 2]
  end

  it 'should always draw when playing itself' do
    players = { 'x' => Tictactoe::Player::PerfectPlayer.new('x'), 'o' => Tictactoe::Player::PerfectPlayer.new('o') }
    results = []
    (1..2).each do
      game_state = make_board('_________', 3, 'x', 'o')
      while game_state.over? == false
        game_state = players[game_state.player_piece].take_turn(game_state)
      end
      results.push game_state.draw?
    end
    results.should_not include false
  end
end
