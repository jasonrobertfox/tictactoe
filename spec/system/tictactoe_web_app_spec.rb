# Encoding: utf-8

require 'spec_helper'

describe 'tic tac toe web application' do

  before(:each) do
    visit '/'
  end
  it 'should have the correct title' do
    page.title.should eq 'Tic Tac Toe'
    page.should have_content "You won't beat me. But you can try."
    page.should have_content 'You Start'
    page.should have_content "I'll Start"
  end

  it 'should start the game when I decide to start', js: true do
    page.should_not have_content 'Go.'
    find('#start-human').click
    page.should have_content 'Go.'
    find('.top-left').click
    page.should have_css('.space i[title=x]')
  end

  it 'should start the game when I tell the computer to start', js: true do
    find('#start-computer').click
    page.should have_css('.space i[title=x]')
  end

  it 'should finish a quickly with foolish move making', skip: true, js: true do
    find('#start-computer').click
    page.should have_css('.space i[title=x]')
    first('.space i[title=\'\']').trigger('click')
    page.should have_css('.space i[title=o]')
    first('.space i[title=\'\']').trigger('click')
    page.should have_content 'I win.'
    page.save_screenshot('build/spec/full_game.png', full: true)
  end

end
