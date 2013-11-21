# Encoding: utf-8

require 'spec_helper'

describe 'default app behavior' do
  it 'should have the correct title' do
    get '/'
    expect(last_response).to be_ok
  end
end
