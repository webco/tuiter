require "rubygems"
require "test/unit"
require "shoulda"
require "mocha"
require 'fakeweb'

require File.dirname(__FILE__) + "/../lib/tuiter"

#Load shoulda macros
%w(macros).each do |dirname|
  Dir[File.dirname(__FILE__) + "/#{dirname}/*.rb"].each do |file|
    require file
  end
end

Logger.any_instance.stubs(:info)
