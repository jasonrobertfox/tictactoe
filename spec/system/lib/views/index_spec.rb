# Encoding: utf-8

require 'spec_helper'

describe 'default app behavior' do
  it 'should have the correct title' do
    visit '/'
    page.title.should eq 'Sinatra Boilerplate'
  end
end
