# Encoding: utf-8

require 'spec_helper'
require 'json'

def post_json(url, data)
  post(url, data.to_json, 'CONTENT_TYPE' => 'application/json')
  JSON.parse(last_response.body)
end

def get_test_board_data(data)
  board = []
  rows = %w(top middle bottom)
  columns = %w(left center right)
  r = 0
  c = 0
  data.each do |row|
    row.each do |column|
      id = "#{rows[r]}-#{columns[c]}"
      board.push(id: id, value: column)
      c == 2 ? c = 0 : c += 1
    end
    r += 1
  end
  board
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

  it 'should return an error if there is no board object defined' do
    data = { piece: 'x' }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 400
    result['status'].should eq 'fail'
    result['data']['message'].should eq 'Board was not defined.'
  end

  it 'should return a data set with next move and other piece if the game is active' do
    data = { piece: 'x', board: get_test_board_data([['x', 'x', ''], ['o', 'o', ''], ['x', 'x', '']]) }
    result = post_json('/api/v1/play', data)
    expect(last_response.status).to be 200
    result['status'].should eq 'success'
    result['data']['piece'].should eq 'o'
    result['data']['board'].count { |space| space['value'] != '' }.should eq 7
  end

  # Other tests
  # what happens if we send a board with a win on it?
  # what happens if we send a draw board?
end
