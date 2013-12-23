# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/web'

describe Tictactoe::Adapter::Web do
  it 'should be initialized with game settings' do
    adapter = get_adapter
    adapter.board_width.should eq 3
    adapter.player_one.should eq 'x'
    adapter.player_two.should eq 'o'
  end

  it 'should respond to get_response' do
    get_adapter.should respond_to :get_response
  end

  it 'should raise an error if the supplied piece is invalid' do
    expect do
      get_adapter.get_response(get_request('d', [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]))
    end.to raise_error ArgumentError, 'Piece was not defined as either x or o.'
  end

  it 'should raise an error if the board is not the right size' do
    expect do
      get_adapter.get_response(get_request('x', [['x', 'x', ''], ['o', 'o', ''], %w(x o)]))
    end.to raise_error ArgumentError, 'Board given contains less than 9 spaces.'
  end
end
