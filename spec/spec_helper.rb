# Encoding: utf-8

# Global testing configurations can be outlined here
ENV['RACK_ENV'] = 'test'
puts 'Loaded global testing configuration.'

# Now depending on this env variable we can pick a specific spec helper
# To improve performance depending on unit or system tests
mode = ENV['TEST_TYPE'] || 'unit'
require "#{mode}/spec_helper"

# Other general helper functions

def get_test_board_data(data)
  board = []
  rows = %w(top middle bottom)
  columns = %w(left center right)
  r = 0
  c = 0
  data.each do |row|
    row.each do |column|
      id = "#{rows[r]}-#{columns[c]}"
      board.push('id' => id, 'value' => column)
      c == 2 ? c = 0 : c += 1
    end
    r += 1
  end
  board
end
