module Tuiter

   class User
    attr_accessor :id
    attr_accessor :name
    attr_accessor :screen_name
    attr_accessor :location
    attr_accessor :description
    attr_accessor :profile_image_url
    attr_accessor :url
    attr_accessor :protected
    attr_accessor :followers_count
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
    attr_accessor :statuses_count
    attr_accessor :notifications
    attr_accessor :following
    attr_accessor :status

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
        @profile_background_color = data["profile_background_color"]
        @profile_text_color = data["profile_text_color"]
        @profile_link_color = data["profile_link_color"]
        @profile_sidebar_fill_color = data["profile_sidebar_fill_color"]
        @profile_sidebar_border_color = data["profile_sidebar_border_color"]
        @friends_count = data["friends_count"].to_i
        @created_at = (data["created_at"] ? DateTime.parse(data["created_at"]) : DateTime.now)
        @favourites_count = data["favourites_count"].to_i
        @utc_offset = data["utc_offset"]
        @time_zone = data["time_zone"]
        @profile_background_image_url = data["profile_background_image_url"]
        @profile_background_tile = data["profile_background_tile"]
        @statuses_count = data["statuses_count"].to_i
        @notifications = data["notifications"]
        @following = data["following"]
        @status = StatusBasic.new(data["status"])
      else
        @created_at = DateTime.now
      end
    end

  end

end

