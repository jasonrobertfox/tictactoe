# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'
require 'tictactoe/player/perfect_player'

def get_player(piece)
  Tictactoe::Player::PerfectPlayer.new(piece)
end

describe Tictactoe::Player::PerfectPlayer do

  it 'should reject a game state where it is not the turn taking player' do
    game_state = get_game_state([['', 'o', 'x'], %w(o o x), %w(x x o)], 'x')
    player = get_player 'o'
    expect do
      player.take_turn(game_state)
    end.to raise_error ArgumentError, 'It is not this player\'s turn.'
  end

  it 'should pick a good opening move if the board is blank' do
    game_state = get_game_state(get_blank_board, 'x')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    # For now we will just pick a random corner for variability
    flat_board = new_state.board.flatten
    [flat_board[0], flat_board[2], flat_board[6], flat_board[8]].should include 'x'
  end

  it 'should simply fill in the last space if there is only one blank' do
    game_state = get_game_state([['', 'o', 'x'], %w(o o x), %w(x x o)], 'x')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.is_draw?.should be_true
  end

  it 'should pick the winning move of a nearly complete game for x' do
    game_state = get_game_state([['x', 'o', ''], ['x', 'x', ''], ['', 'o', 'o']], 'x')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 2
    new_state.have_i_won?(player).should be_true
  end

  it 'should pick the winning move of a nearly complete game for o' do
    game_state = get_game_state([%w(x o x), ['x', 'x', ''], ['', 'o', 'o']], 'o')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.have_i_won?(player).should be_true
  end

  it 'should pick the winning move from a more incomplete game' do
    game_state = get_game_state([['x', '', 'x'], ['', 'o', ''], ['', 'o', '']], 'x')
    player = get_player 'x'
    new_state = player.take_turn(game_state)
    new_state.have_i_won?(player).should be_true
  end

  it 'should pick the next move from a more incomplete game' do
    game_state = get_game_state([['x', '', ''], ['', '', ''], ['', '', '']], 'o')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 7
    new_state.is_over?.should be_false
  end

  it 'should clearly block a move' do
    game_state = get_game_state([['', '', ''], ['', 'x', ''], ['x', '', 'o']], 'o')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 5
    new_state.is_over?.should be_false
    new_state.board.should eq [['', '', 'o'], ['', 'x', ''], ['x', '', 'o']]
  end

  it 'should clearly block a move 2' do
    game_state = get_game_state([['o', '', ''], ['', '', 'x'], ['', '', 'x']], 'o')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.available_moves.length.should eq 5
    new_state.is_over?.should be_false
    new_state.board.should eq [['o', '', 'o'], ['', '', 'x'], ['', '', 'x']]
  end

  it 'should work with an alternative state' do
    player = get_player 'z'
    new_state = player.take_turn(get_alternative_game_state)
    new_state.board.should eq [['z', ''], %w(z j)]
  end

  it 'should clearly block a move 3' do
    game_state = get_game_state([['', 'x', ''], ['', '', 'x'], %w(o o x)], 'o')
    player = get_player 'o'
    new_state = player.take_turn(game_state)
    new_state.is_over?.should be_false
    new_state.board.should eq [['', 'x', 'o'], ['', '', 'x'], %w(o o x)]
  end

  it 'should always draw when playing itself', :skip do
    players = { 'x' => Tictactoe::Player::PerfectPlayer.new('x'), 'o' => Tictactoe::Player::PerfectPlayer.new('o') }
    # for 10 games
    results = []
    (1..10).each do
      game_state = get_game_state(get_blank_board, 'x')
      while game_state.is_over? == false
        game_state = players[game_state.player_piece].take_turn(game_state)
      end
      results.push game_state.is_draw?
    end
    results.should_not include false
  end
end
