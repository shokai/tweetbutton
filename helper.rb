require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader'
require 'yaml'
require 'json'
require 'oauth'
require 'twitter'
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end

if production?
  use Rack::Session::Cookie,
  :key => 'rack.session',
  :domain => @@conf['session_domain'],
  :path => '/',
  :expire_after => 60*60*24*14, # 2 weeks
  :secret => @@conf['session_secret']
end

def consumer
  OAuth::Consumer.new(@@conf['twitter_key'], @@conf['twitter_secret'],
                      :site => "http://twitter.com")
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

