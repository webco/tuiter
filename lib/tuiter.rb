require 'open-uri'
require 'uri'
require 'net/http'
require 'logger'
require 'oauth'

require 'json'

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

# Constants
TWITTER_API_BASE_URL = "http://twitter.com"

# Utils
require 'tuiter/utils'

# Tuiter API methods modules
require 'tuiter/methods/status'
require 'tuiter/methods/user'
require 'tuiter/methods/direct_message'
require 'tuiter/methods/friendship'
require 'tuiter/methods/social_graph'
require 'tuiter/methods/account'
require 'tuiter/methods/block'
require 'tuiter/methods/timeline'

# Tuiter data structures
require 'tuiter/data/user'
require 'tuiter/data/status'
require 'tuiter/data/rate_limit'
require 'tuiter/data/direct_message'

# Tuiter client and end points
require 'tuiter/client'

