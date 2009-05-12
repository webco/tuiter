# Social Graph Methods
# [X] friends/ids
# [X] followers/ids
# [ ] add parameters to the friends/ids method
# [ ] add parameters to the followers/ids method

module Tuiter

  module SocialGraphMethods
    
    def followers_ids 
      if res = @request_handler.get("http://twitter.com/followers/ids/#{username}.json").body
        return JSON.parse(res)
      else
        return nil
      end
    end

    def friends_ids 
      if res = @request_handler.get("http://twitter.com/friends/ids/#{username}.json").body
        return JSON.parse(res)
      else
        return nil
      end
    end
  end

end

