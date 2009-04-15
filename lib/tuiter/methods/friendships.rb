module FriendshipMethods

  def friendships_create(user, follow = nil)
    log("friendship_new() following: #{user}")
    url = URI.parse("http://twitter.com/friendships/create/#{user}.json")
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @username, @password
    req.set_form_data({'follow'=>"true"}) if follow
    res = new_http_for(url).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      log("friendship_new() success: OK")
      return res # OK
    else
      log("friendship_new() error: #{res.error!}")
      res.error!
    end
  end

  def friendships_destroy(user, follow = nil)
    log("friendship_new() following: #{user}")
    url = URI.parse("http://twitter.com/friendships/destroy/#{user}.json")
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @username, @password
    res = new_http_for(url).start {|http| http.request(req) }
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
    if res = request("http://twitter.com/friendships/exists.json?user_a=#{id}&user_b=#{@username}")
      return true if res == "true"
      return false
    else
      return nil
    end
  end
end