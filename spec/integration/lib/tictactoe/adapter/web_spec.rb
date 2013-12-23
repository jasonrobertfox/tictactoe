# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/web'

describe Tictactoe::Adapter::Web do
  it 'should raise an error if the board is in a draw' do
    expect do
      get_adapter.get_response(get_request('x', [%w(x x o), %w(o o x), %w(x o o)]))
    end.to raise_error ArgumentError, 'Nothing to do, the board provided is a draw.'
  end

  it 'should raise an error if the board is in a win state' do
    expect do
      get_adapter.get_response(get_request('x', [%w(x x x), ['o', 'o', ''], ['x', 'o', '']]))
    end.to raise_error ArgumentError, 'Nothing to do, there is already a winner.'
  end

  it 'should return a response with a new game state' do
    response = get_adapter.get_response(get_request('x', [['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]))
    response[:piece].should eq 'o'
    response[:board].count { |space| space['value'] != '' }.should eq 7
  end
end
