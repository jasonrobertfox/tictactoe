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
  it 'should return an error if the piece is not provided' do
    data = {}
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['status'].should eq 'fail'
    result['data']['message'].should eq 'Piece was not defined as either x or o.'
  end

  it 'should return an error if the piece is invalid' do
    data = { piece: 'b' }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['status'].should eq 'fail'
    result['data']['message'].should eq 'Piece was not defined as either x or o.'
  end

  it 'should handle the exception if a board validation exception is raised' do
    data = { piece: 'x', board: get_test_board_data([['x', 'b', ''], ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['status'].should eq 'fail'
    result['data']['message'].should eq 'Board contains invalid pieces.'
  end

  it 'should return a data set with next move and other piece if the game is active' do
    data = { piece: 'x', board: get_test_board_data([['x', 'x', ''], ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 200
    result['status'].should eq 'success'
    result['data']['piece'].should eq 'o'
    result['data']['board'].count { |space| space['value'] != '' }.should eq 7
  end

  it 'should reject a board that is in a draw state' do
    data = { piece: 'x', board: get_test_board_data([%w(x x o), %w(o o x), %w(x o o)]) }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['data']['message'].should eq 'Nothing to do, the board provided is a draw.'
  end

  it 'should reject a board that is already in a wining state' do
    data = { piece: 'x', board: get_test_board_data([%w(x x x), ['o', 'o', ''], ['x', 'o', '']]) }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['data']['message'].should eq 'Nothing to do, there is already a winner.'
  end
end
