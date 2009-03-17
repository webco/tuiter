require 'tuiter'

client = Tuiter::Client.new(:username => 'screen_name', :password => 'password')

15.times do
  client.update('All work and no play makes Jack a dull boy')
end

