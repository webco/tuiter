module Tuiter

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
        @created_at = (data["created_at"] ? DateTime.parse(data["created_at"]) : DateTime.now)
        @id = data["id"]
        @text = data["text"]
        @source = data["source"]
        @truncated = data["truncated"]
        @in_reply_to_status_id = data["in_reply_to_status_id"]
        @in_reply_to_user_id = data["in_reply_to_user_id"]
        @favorited = data["favorited"]
        @in_reply_to_screen_name = data["in_reply_to_screen_name"]
      else
        @created_at = DateTime.now
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

