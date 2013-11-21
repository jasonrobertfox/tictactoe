# Encoding: utf-8

# Global testing configurations can be outlined here
ENV['RACK_ENV'] = 'test'
puts 'Loaded global testing configuration.'

# Now depending on this env variable we can pick a specific spec helper
# To improve performance depending on unit or system tests
mode = ENV['TEST_TYPE'] || 'unit'
require "#{mode}/spec_helper"
