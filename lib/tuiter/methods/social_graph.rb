# Social Graph Methods
# [ ] friends/ids
# [X] followers/ids

module SocialGraphMethods
  
  def followers_ids 
    if res = request("http://twitter.com/followers/ids/#{username}.json")
      return JSON.parse(res)
    else
      return nil
    end
  end
  
end