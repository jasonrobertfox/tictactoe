# Encoding: utf-8

require 'simplecov'
require 'coveralls'

coverage = ENV['COVERAGE'] || false

# Only create coverage if specified to speed up guard tests
if coverage
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    coverage_dir 'build/coverage'
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding skip: true
  config.filter_run :focus
  config.order = 'random'
end

puts 'Loaded unit testing configuration.'
