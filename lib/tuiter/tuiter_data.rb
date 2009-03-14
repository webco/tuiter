# This library provides basic access to the Twitter API.
# It was developed for my experimental project called
# Tuitersfera Brasil. Tuitersfera Brasil is an application
# to monitor the Twitter usage in Brazil.
#
# Author::    Manoel Lemos  (mailto:manoel@lemos.net)
# Copyright:: Copyright (c) 2009 Manoel Lemos
# License::   Distributes under the same terms as Ruby

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
  
  
  class UserBasic
    attr_accessor :id
    attr_accessor :name
    attr_accessor :screen_name
    attr_accessor :location
    attr_accessor :description
    attr_accessor :profile_image_url
    attr_accessor :url
    attr_accessor :protected
    attr_accessor :followers_count

    def initialize(data = nil)
      unless data.nil?
        @id = data["id"]
        @name = data["name"]
        @screen_name = data["screen_name"]
        @location = data["location"]
        @description = data["description"]
        @profile_image_url = data["profile_image_url"]
        @url = data["url"]
        @protected = data["protected"]
        @followers_count = data["followers_count"]
      end
    end

  end
  
  
  class UserExtended < UserBasic
    attr_accessor :profile_background_color
    attr_accessor :profile_text_color
    attr_accessor :profile_link_color
    attr_accessor :profile_sidebar_fill_color
    attr_accessor :profile_sidebar_border_color
    attr_accessor :friends_count
    attr_accessor :created_at
    attr_accessor :favourites_count
    attr_accessor :utc_offset
    attr_accessor :time_zone
    attr_accessor :profile_background_image_url
    attr_accessor :profile_background_tile
    attr_accessor :following
    attr_accessor :notifications
    attr_accessor :statuses_count

    def initialize(data = nil)
      unless data.nil?
        super(data)
        @profile_background_color = data["profile_background_color"]
        @profile_text_color = data["profile_text_color"]
        @profile_link_color = data["profile_link_color"]
        @profile_sidebar_fill_color = data["profile_sidebar_fill_color"]
        @profile_sidebar_border_color = data["profile_sidebar_border_color"]
        @friends_count = data["friends_count"].to_i
        @created_at = Time.parse(data["created_at"])
        @favourites_count = data["favourites_count"].to_i
        @utc_offset = data["utc_offset"]
        @time_zone = data["time_zone"]
        @profile_background_image_url = data["profile_background_image_url"]
        @profile_background_tile = data["profile_background_tile"]
        @following = data["following"]
        @notifications = data["notifications"]
        @statuses_count = data["statuses_count"].to_i
      end
    end

  end
  
  
  class StatusBasic
    attr_accessor :created_at
    attr_accessor :id
    attr_accessor :text
    attr_accessor :source
    attr_accessor :truncated
    attr_accessor :in_reply_to_status_id
    attr_accessor :in_reply_to_user_id
    attr_accessor :favorited
    attr_accessor :in_reply_to_screen_name

    def initialize(data = nil)
      unless data.nil?
        @created_at = Time.parse(data["created_at"])
        @id = data["id"]
        @text = data["text"]
        @source = data["source"]
        @truncated = data["truncated"]
        @in_reply_to_status_id = data["in_reply_to_status_id"]
        @in_reply_to_user_id = data["in_reply_to_user_id"]
        @favorited = data["favorited"]
        @in_reply_to_screen_name = data["in_reply_to_screen_name"]
      end
    end  

  end
  
  
  class User < UserBasic
    attr_accessor :status

    def initialize(data=nil)
      unless data.nil?
        super(data)
        @status = StatusBasic.new(data["status"])
      end
    end

  end
  
  
  class Status < StatusBasic
    attr_accessor :user

    def initialize(data=nil)
      unless data.nil?
        super(data)
        @user = UserBasic.new(data["user"])
      end
    end

  end
  
end