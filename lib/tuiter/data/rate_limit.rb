module Tuiter
  
  class RateLimit
    attr_accessor :reset_time
    attr_accessor :reset_time_in_seconds
    attr_accessor :reset_window
    attr_accessor :remaining_hits
    attr_accessor :hourly_limit

    def initialize(data = nil)
      unless data.nil?
        @reset_time_in_seconds = Time.at(data["reset_time_in_seconds"].to_i)
        @reset_time = Time.parse(data["reset_time"])
        @reset_window = @reset_time - Time.now
        @remaining_hits = data["remaining_hits"].to_i
        @hourly_limit = data["hourly_limit"].to_i
      end
    end

  end
end

