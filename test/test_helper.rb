require "rubygems"
require "test/unit"
require "shoulda"
require "mocha"

# begin
#   require "quietbacktrace"
#   Test::Unit::TestCase.quiet_backtrace = true
#   Test::Unit::TestCase.backtrace_silencers = [:test_unit, :gem_root, :e1]
#   Test::Unit::TestCase.backtrace_filters = [:method_name]
# rescue LoadError
#   # Just ignore it
# end

require File.dirname(__FILE__) + "/../lib/tuiter"

#Load shoulda macros
%w(macros).each do |dirname|
  Dir[File.dirname(__FILE__) + "/#{dirname}/*.rb"].each do |file|
    require file
  end
end