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

# TODO: move these back into test for production deployment
gem 'rspec', '2.14.1'
gem 'rubocop'
gem 'rake'
gem 'jasmine', '1.3.2'
gem 'jasmine-phantom'
group :test do
  gem 'coveralls'
  gem 'capybara', '2.1.0'
  gem 'poltergeist'
  gem 'ruby-prof'
end

group :development do
  gem 'guard', '2.2.3'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-livereload'
  gem 'guard-shotgun', git: 'https://github.com/rchampourlier/guard-shotgun.git', branch: 'master'
  gem 'blam', '1.3.0'
  gem 'flay'
  gem 'reek'
end
