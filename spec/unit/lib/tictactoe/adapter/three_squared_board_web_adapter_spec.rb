# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/three_squared_board_web_adapter'

describe Tictactoe::Adapter::ThreeSquaredBoardWebAdapter do
  it 'should be initialized with game settings' do
    adapter = test_adapter
    adapter.board_width.should eq 3
    adapter.player_one.should eq 'x'
    adapter.player_two.should eq 'o'
  end

  it 'should respond to get_response' do
    test_adapter.should respond_to :get_response
  end

  it 'should raise an error if the supplied piece is invalid' do
    expect do
      test_adapter.get_response(test_request('d', [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]))
    end.to raise_error ArgumentError, 'Piece was not defined as either x or o.'
  end

  it 'should raise an error if the board is not the right size' do
    expect do
      test_adapter.get_response(test_request('x', [['x', 'x', ''], ['o', 'o', ''], %w(x o)]))
    end.to raise_error ArgumentError, 'Board given contains less than 9 spaces.'
  end
end
