
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

if development?
  set :sessions, true
elsif production?
  use Rack::Session::Cookie,
  :key => 'rack.session',
  :domain => Conf['session_domain'],
  :path => '/',
  :expire_after => 60*60*24*14, # 2 weeks
  :secret => Conf['session_secret']
end

def consumer
  OAuth::Consumer.new(Conf['twitter_key'], Conf['twitter_secret'],
                      :site => "http://twitter.com")
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

