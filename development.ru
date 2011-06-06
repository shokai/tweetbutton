require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__)+'/helper'
require File.dirname(__FILE__)+'/main'

set :environment, :development
set :sessions, true

set :port, 8091
set :server, 'thin'

Sinatra::Application.run
