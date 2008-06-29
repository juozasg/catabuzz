#!/usr/bin/ruby

ENV["RAILS_ENV"]="production"

require 'config/environment'
#require 'console_app'
eval ARGV[0]
