# User Methods
# [X] statuses/friends
# [X] statuses/followers
# [X] users/show

module Tuiter

  module UserMethods

    def statuses_friends(options = {})
      if options[:id]
        query = "http://twitter.com/statuses/friends/#{options[:id]}.json"
      else
        query = "http://twitter.com/statuses/friends.json"
      end
      if options[:page]
        params = "?page=#{options[:page]}"
      else
        params = ""
      end
      if res = @request_handler.get(query+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::User.new(d) }
      else
        return nil
      end
    end
    
    def statuses_followers(options = {})
      if options[:id]
        query = "http://twitter.com/statuses/followers/#{options[:id]}.json"
      else
        query = "http://twitter.com/statuses/followers.json"
      end
      if options[:page]
        params = "?page=#{options[:page]}"
      else
        params = ""
      end
      if res = @request_handler.get(query+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::User.new(d) }
      else
        return nil
      end
    end
    
    def users_show(id)
      if res = @request_handler.get("http://twitter.com/users/show/#{id}.json").body
        return Tuiter::User.new(JSON.parse(res))
      else
        return nil
      end
    end

  end

end

