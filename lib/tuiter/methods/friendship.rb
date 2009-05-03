# Friendship Methods
# [X] friendships/create
# [X] friendships/destroy
# [X] friendships/exists

module Tuiter

  module FriendshipMethods

    def friendships_create(user, follow = nil)
      log("friendship_new() following: #{user}")
      res = @request_handler.post("/friendships/create/#{user}.json", (follow ? {'follow'=>"true"} : "" ))
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("friendship_new() success: OK")
        return res # OK
      else
        log("friendship_new() error: #{res.error!}")
        res.error!
      end
    end

    def friendships_destroy(user)
      log("friendship_new() following: #{user}")
      res = @request_handler.post("/friendships/destroy/#{user}.json")
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("remove_friendship() success: OK")
        return res # OK
      else
        log("remove_friendship() error: #{res.error!}")
        res.error!
      end
    end
    
    def friendships_exists?(id)
      if res = @request_handler.get("http://twitter.com/friendships/exists.json?user_a=#{id}&user_b=#{@username}").body
        return true if res == "true"
        return false
      else
        return nil
      end
    end

  end

end

