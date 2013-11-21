# Encoding: utf-8

source 'https://rubygems.org'
ruby '2.0.0'

gem 'sinatra'
gem 'sinatra-contrib', require: %w(sinatra/config_file)
gem 'thin'
gem 'slim'
gem 'sinatra-assetpack'
gem 'zurb-foundation'
gem 'compass'

group :application do
  # Here should be all the specifics for the application
end

group :test do
  gem 'rspec'
  gem 'coveralls'
  gem 'capybara'
  gem 'rubocop'
end

group :development do
  gem 'rake'
  gem 'guard', '2.2.3'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-livereload'
  gem 'guard-shotgun', git: 'git@github.com:rchampourlier/guard-shotgun.git', branch: 'master'
  gem 'blam'
end
