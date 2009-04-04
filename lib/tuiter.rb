require 'open-uri'
require 'uri'
require 'net/http'
require 'logger'

require 'json'

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

# Tuiter client and end points
require 'tuiter/client'

# Tuiter data structures
require 'tuiter/data/user'
require 'tuiter/data/status'
require 'tuiter/data/rate_limit'
require 'tuiter/data/direct_message'

