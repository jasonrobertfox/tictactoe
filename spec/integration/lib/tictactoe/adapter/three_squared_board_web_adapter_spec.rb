# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/three_squared_board_web_adapter'

describe Tictactoe::Adapter::ThreeSquaredBoardWebAdapter do
  it 'should raise an error if the board is in a draw' do
    expect do
      test_adapter.get_response(test_request('x', [%w(x x o), %w(o o x), %w(x o o)]))
    end.to raise_error ArgumentError, 'Nothing to do, the board provided is a draw.'
  end

  it 'should raise an error if the board is in a win state' do
    expect do
      test_adapter.get_response(test_request('x', [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]))
    end.to raise_error ArgumentError, 'Nothing to do, there is already a winner.'
  end

  it 'should return a response with a new game state' do
    response = test_adapter.get_response(test_request('x', [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]))
    response[:piece].should eq 'o'
    response[:board].count { |space| space['value'] != '' }.should eq 7
  end
end
