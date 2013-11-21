# Encoding: utf-8

require 'spec_helper'

describe 'default app behavior' do
  it 'should have the correct title' do
    visit '/'
    page.title.should eq 'Tic Tac Toe'
    page.should have_content "You won't beat me. But you can try."
    page.should have_content 'You Start'
    page.should have_content "I'll Start"
  end
end
