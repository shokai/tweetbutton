#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  @title = 'Tweet Button'
end

get '/' do
  haml :index
end

get '/t/*' do
  @message = params[:splat].join('/')
  redirect app_root if !@message or @message.size < 1
  if auth?
    session[:tweet_message] = nil
  else
    session[:tweet_message] = @message
  end
  haml :tweet
end

post '/tweet' do
  message = params['message']
  if !message or message.to_s.size < 1
    @mes = {:error => 'message is null'}.to_json
  else
    begin
      Twitter.configure do |config|
        config.consumer_key = Conf['twitter']['key']
        config.consumer_secret = Conf['twitter']['secret']
        config.oauth_token = session[:access_token]
        config.oauth_token_secret = session[:access_token_secret]
      end
      res = Twitter.update "#{message} #tweet_button #{'　'*rand(10)}"
      @mes = {:message => message, :response => res}.to_json
    rescue => e
      STDERR.puts e
      @mes = {:error => 'tweet failed', :message => message, :response => e.to_s}.to_json
    end
  end
end
