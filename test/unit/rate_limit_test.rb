require File.dirname(__FILE__) + "/../test_helper"

class RateLimitTest < Test::Unit::TestCase
  RATE_LIMIT_ATTRIBUTES = %w(reset_time reset_time_in_seconds reset_window remaining_hits hourly_limit)
  
  context "RateLimit" do
    should_attr_accessor_for Tuiter::RateLimit, RATE_LIMIT_ATTRIBUTES
    
    should_load_attribute_on_initialize Tuiter::RateLimit, "reset_time_in_seconds", Time.at(1234567890), 1234567890
    
    
  end # context "RateLimit"
  
end

