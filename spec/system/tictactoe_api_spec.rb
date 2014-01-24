# Encoding: utf-8

require 'spec_helper'
require 'json'

def post_json(url, data)
  post(url, data.to_json, 'CONTENT_TYPE' => 'application/json')
  JSON.parse(last_response.body)
end

describe 'default app behavior' do
  it 'should have the correct title' do
    get '/'
    expect(last_response).to be_ok
  end
end

describe 'tic tac toe api behavior' do
  it 'should handle the exception from lower level components' do
    data = { player_piece: 'b', opponent_piece: 'b', board: test_board_data([['x', 'o', ''], ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v2/play', data)
    expect(last_response.status).to eq 400
    result['status'].should eq 'fail'
    result['data']['message'].should_not be_empty
  end

  it 'should return a data set with next move and other piece if the game is active' do
    data = { player_piece: 'x', opponent_piece: 'o', board: test_board_data([['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v2/play', data)
    expect(last_response.status).to eq 200
    result['status'].should eq 'success'
    result['data']['player_piece'].should eq 'o'
    result['data']['board'].count { |space| space['value'] != '' }.should eq 7
  end

  it 'should return update the board with draw status' do
    data = { player_piece: 'x', opponent_piece: 'o', board: test_board_data([%w(x x o), %w(o o x), %w(x o o)]) }
    result = post_json('/api/v2/play', data)
    expect(last_response.status).to eq 200
    result['data']['status'].should eq 'draw'
  end

  it 'should update the board with winning status ' do
    data = { player_piece: 'x', opponent_piece: 'o', board: test_board_data([%w(x x x), ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v2/play', data)
    expect(last_response.status).to eq 200
    result['data']['status'].should eq 'win'
    result['data']['winner'].should eq 'x'
    result['data']['board'][1]['winning_space'].should eq true
    result['data']['board'][5]['winning_space'].should be_nil
  end
end
