# Social Graph Methods
# [ ] friends/ids
# [X] followers/ids

module Tuiter

  module SocialGraphMethods
    
    def followers_ids 
      if res = @request_handler.get("http://twitter.com/followers/ids/#{username}.json").body
        return JSON.parse(res)
      else
        return nil
      end
    end

  end

end

