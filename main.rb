#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  @title = 'Tweet Button'
end

def auth?
  return true if session[:access_token] and session[:access_token_secret]
  return false
end

get '/' do
  haml :index
end

get '/t/*' do
  redirect app_root unless auth?
  @message = params[:splat].join('/')
  haml :tweet
end

post '/tweet' do
  message = params['message']
  if !message or message.to_s.size < 1
    @mes = {:error => 'message is null'}.to_json
  else
    begin
      Twitter.configure do |config|
        config.consumer_key = @@conf['twitter_key']
        config.consumer_secret = @@conf['twitter_secret']
        config.oauth_token = session[:access_token]
        config.oauth_token_secret = session[:access_token_secret]
      end
      res = Twitter.update message
      @mes = {:message => message, :response => res}.to_json
    rescue => e
      STDERR.puts e
      @mes = {:error => 'tweet failed', :message => message, :response => e.to_s}.to_json
    end
  end
end

get '/login' do
  begin
    request_token = consumer.get_request_token(:oauth_callback => "#{app_root}/auth")
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect request_token.authorize_url
  rescue => e
    STDERR.puts e
    redirect app_root
  end
end

get '/auth' do
  begin
    request_token = OAuth::RequestToken.new(consumer,
                                            session[:request_token],
                                            session[:request_token_secret])
    access_token = request_token.get_access_token({},
                                                  :oauth_token => params[:oauth_token],
                                                  :oauth_verifier => params[:oauth_verifier])
    session[:access_token] = access_token.token
    session[:access_token_secret] = access_token.secret
    Twitter.configure do |config|
      config.consumer_key = @@conf['twitter_key']
      config.consumer_secret = @@conf['twitter_secret']
      config.oauth_token = session[:access_token]
      config.oauth_token_secret = session[:access_token_secret]
    end
    user = Twitter.user
    session[:twitter_icon] = user.profile_image_url
    session[:twitter_name] = user.screen_name
  rescue => e
    STDERR.puts e
  end
  redirect app_root
end

get '/logout' do
  session[:access_token] = nil
  session[:access_token_secret] = nil
  session[:twitter_icon] = nil
  session[:twitter_name] = nil
  redirect app_root
end
