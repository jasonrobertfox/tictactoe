# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/game_state'
require 'tictactoe/player/perfect_player'

def get_blank_board
  [['', '', ''], ['', '', ''], ['', '', '']]
end

describe Tictactoe::Player::PerfectPlayer do

  it 'should simply fill in the last space if there is only one blank' do
    game_state = Tictactoe::GameState.new([['', 'o', 'x'], %w(o o x), %w(x x o)], 'x')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.draw?.should be_true
  end

  it 'should pick a good opening move if the board is blank' do
    game_state = Tictactoe::GameState.new([['', '', ''], ['', '', ''], ['', '', '']], 'x')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    # For now we will just pick a random corner for variability
    flat_board = new_state.board.flatten
    [flat_board[0], flat_board[2], flat_board[6], flat_board[8]].should include 'x'
  end

  it 'should pick the winning move of a nearly complete game for x' do
    game_state = Tictactoe::GameState.new([['x', 'o', ''], ['x', 'x', ''], ['', 'o', 'o']], 'x')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 2
    new_state.win?('x').should be_true
  end

  it 'should pick the winning move of a nearly complete game for o' do
    game_state = Tictactoe::GameState.new([%w(x o x), ['x', 'x', ''], ['', 'o', 'o']], 'o')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.win?('o').should be_true
  end

  it 'should pick the winning move from a more incomplete game' do
    game_state = Tictactoe::GameState.new([['x', '', 'x'], ['', 'o', ''], ['', 'o', '']], 'x')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.win?('x').should be_true
  end

  it 'should pick the next move from a more incomplete game' do
    game_state = Tictactoe::GameState.new([['x', '', ''], ['', '', ''], ['', '', '']], 'o')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 7
    new_state.over?.should be_false
  end

  it 'should clearly block a move' do
    game_state = Tictactoe::GameState.new([['', '', ''], ['', 'x', ''], ['x', '', 'o']], 'o')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 5
    new_state.over?.should be_false
    new_state.board.should eq [['', '', 'o'], ['', 'x', ''], ['x', '', 'o']]
  end

  it 'should clearly block a move 2' do
    game_state = Tictactoe::GameState.new([['o', '', ''], ['', '', 'x'], ['', '', 'x']], 'o')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.get_blanks.length.should eq 5
    new_state.over?.should be_false
    new_state.board.should eq [['o', '', 'o'], ['', '', 'x'], ['', '', 'x']]
  end

  it 'should clearly block a move 3' do
    game_state = Tictactoe::GameState.new([['', 'x', ''], ['', '', 'x'], %w(o o x)], 'o')
    player = Tictactoe::Player::PerfectPlayer.new
    new_state = player.get_new_state(game_state)
    new_state.over?.should be_false
    new_state.board.should eq [['', 'x', 'o'], ['', '', 'x'], %w(o o x)]
  end

  it 'should always draw when playing itself' do
    players = { 'x' => Tictactoe::Player::PerfectPlayer.new, 'o' => Tictactoe::Player::PerfectPlayer.new }
    # for 10 games
    results = []
    (1..10).each do
      game_state = Tictactoe::GameState.new(get_blank_board, 'x')
      while game_state.over? == false
        game_state = players[game_state.active_turn].get_new_state(game_state)
      end
      results.push game_state.draw?
    end
    results.should_not include false
  end
end
