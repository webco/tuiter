require 'open-uri'
require 'uri'
require 'net/http'
require 'logger'

require 'json'

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'tuiter/client'
require 'tuiter/data/user'
require 'tuiter/data/status'
require 'tuiter/data/rate_limit'
