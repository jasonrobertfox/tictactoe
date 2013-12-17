# Encoding: utf-8

source 'https://rubygems.org'
ruby '2.0.0'

gem 'sinatra'
gem 'sinatra-contrib', require: %w(sinatra/config_file sinatra/namespace)
gem 'thin'
gem 'slim'
gem 'sinatra-assetpack'
gem 'zurb-foundation', '4.3.2'
gem 'compass'

group :application do
  # Here should be all the specifics for the application
end

# TODO: move these back into test for production deployment
gem 'rspec'
gem 'rubocop'
gem 'rake'
group :test do
  gem 'coveralls'
  gem 'capybara', '2.1.0'
  gem 'poltergeist'
end

group :development do
  gem 'guard', '2.2.3'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-livereload'
  gem 'guard-shotgun'
  gem 'blam'
end
