require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra'
require 'sinatra/reloader' if development?
$stdout.sync = true if development?
require 'yaml'
require 'json'
require 'oauth'
require 'twitter'

require File.dirname(__FILE__)+'/helper'
require File.dirname(__FILE__)+'/main'

run Sinatra::Application
