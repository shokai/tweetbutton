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
require File.dirname(__FILE__)+'/bootstrap'
Bootstrap.init :helpers, :controllers

set :haml, :escape_html => true

run Sinatra::Application
