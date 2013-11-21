# Encoding: utf-8

require 'spec_helper'
require 'app/version'

describe App::Version do
  it 'should return the version with get method' do
    App::Version.get.should eq '0.0.0'
  end
end
