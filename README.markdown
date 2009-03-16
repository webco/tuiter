# Tuiter #

Tuiter was design and developed by Manoel Lemos (manoel@lemos.net), to provide access to the Twitter API. It was developed for the experimental project called [Tuitersfera Brasil](http://tuitersfera.com.br), an application to monitor the Twitter usage in Brazil.

# Basic Usage #

    require 'tuiter'
    client = Tuiter::Client.new(:username => '<twitter_login>', :password => '<twitter_pwd>')
    client.update('Hey Ho, Twitters!')

# Current Status #

Tuiter is currently being extracted from Tuitersfera and transformed into a full-fledged Ruby library.

Stay in tune for updates!

