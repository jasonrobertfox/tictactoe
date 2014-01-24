# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/three_squared_board_web_adapter'

describe Tictactoe::Adapter::ThreeSquaredBoardWebAdapter do

  let(:test_adapter) { Tictactoe::Adapter::ThreeSquaredBoardWebAdapter.new }

  it 'should return the board with draw status if the board is already a draw' do
    response = test_adapter.get_response(test_request('x', 'o', [%w(x x o), %w(o o x), %w(x o o)]))
    response[:status].should eq 'draw'
  end

  it 'should return the board with win status and winning spaces if its a win' do
    response = test_adapter.get_response(test_request('x', 'o', [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]))
    response[:status].should eq 'win'
    response[:winner].should eq 'x'
    response[:board][0][:winning_space].should eq true
    response[:board][1][:winning_space].should eq true
    response[:board][2][:winning_space].should eq true
    response[:board][3][:winning_space].should be_nil
  end

  it 'should return a response with a new game state and win information if the turn completes the game' do
    response = test_adapter.get_response(test_request('x', 'o', [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]))
    response[:player_piece].should eq 'o'
    response[:opponent_piece].should eq 'x'
    response[:board].count { |space| space[:value] != '' }.should eq 7
    response[:status].should eq 'win'
    response[:winner].should eq 'x'
    response[:board][0][:winning_space].should eq true
    response[:board][1][:winning_space].should eq true
    response[:board][2][:winning_space].should eq true
  end

  it 'should return a response with a new game state and show active status if the game is ongoing' do
    response = test_adapter.get_response(test_request('x', 'o', [['x', '', ''], ['o', 'o', ''], ['x', '', '']]))
    response[:player_piece].should eq 'o'
    response[:opponent_piece].should eq 'x'
    response[:board].count { |space| space[:value] != '' }.should eq 5
    response[:status].should eq 'active'
    response[:winner].should be_nil
  end
end
