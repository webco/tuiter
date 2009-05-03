require 'tuiter'

# HTTP Basic Auth example
client = Tuiter::Client.new(:authentication => :basic, :username => 'screen_name', :password => 'password')

15.times do
  client.update('All work and no play makes Jack a dull boy')
end


# OAuth example
client = Tuiter::Client.new(:authentication => :oauth, :consumer_key => 'YOUR_KEY', :consumer_secret => 'YOUR_SECRET')

rtoken = client.request_token
# waits for token
# stores token and secret
token, secret = rtoken.token, rtoken.secret
# redirect to authorize url
rtoken.authorize_url
# user authenticate in twitter domains
# and then Twitter access the callback url with the access token
access_token = client.authorize(token,secret)
# checks if everything's ok
if client.authorized?
  # and have fun
  15.times do
    client.update('All work and no play makes Jack a dull boy')
  end
end