# Encoding: utf-8

# Global testing configurations can be outlined here
ENV['RACK_ENV'] = 'test'
require 'rspec'

# Now depending on this env variable we can conditionally require the dependencies for
# each type of test
# To improve performance depending on unit or system tests
test_types = ENV['TEST_TYPE']  ? [ENV['TEST_TYPE']] : %w(unit system)

puts "Tests configured for #{test_types.inspect}"

if test_types.include? 'system'
  require 'rack/test'
  require 'sinatra'
  require 'capybara/rspec'
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'
  require_relative '../lib/app'
end

# Include coverage if the environment variable is set
coverage = ENV['COVERAGE'] || false
# Only create coverage if specified to speed up guard tests
if coverage
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter 'spec'
    coverage_dir 'build/coverage'
  end
end

# Standard rspec configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding skip: true
  config.filter_run :focus
  config.order = 'random'
end

# Rspec configuration specific to system tests
if test_types.include? 'system'
  RSpec.configure do |config|
    config.expect_with :rspec, :stdlib
    config.include Rack::Test::Methods
    config.include Capybara::DSL
    def app
      App::Server
    end
  end

  Capybara.app = App::Server
  Capybara.javascript_driver = :poltergeist
end

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
