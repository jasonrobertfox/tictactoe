# Encoding: utf-8

require 'spec_helper'
require 'tictactoe/adapter/three_squared_board_web_adapter'

describe Tictactoe::Adapter::ThreeSquaredBoardWebAdapter do

  let(:test_adapter) { Tictactoe::Adapter::ThreeSquaredBoardWebAdapter.new }

  it 'should be initialized' do
    test_adapter.should be_an_instance_of Tictactoe::Adapter::ThreeSquaredBoardWebAdapter
  end

  it 'should respond to get_response' do
    test_adapter.should respond_to :get_response
  end

end
