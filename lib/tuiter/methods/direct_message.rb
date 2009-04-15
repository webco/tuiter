# Direct Message Methods
# [X] direct_messages
# [ ] direct_messages/sent
# [X] direct_messages/new
# [ ] direct_messages/destroy

module DirectMessageMethods
  
  def direct_messages(options = {})
    url = 'http://twitter.com/direct_messages.json'
    params = parse_options(options) || ""

    if res = request(url+params)
      data = JSON.parse(res)
      return data.map { |d| Tuiter::DirectMessage.new(d) }
    else
      return nil
    end
  end
  
  def direct_messages_new(user, text)
    log("direct_new() sending: #{text} to #{user}")
    url = URI.parse('http://twitter.com/direct_messages/new.json')
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @username, @password
    req.set_form_data({'user'=>user, 'text'=>text })
    res = new_http_for(url).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      log("direct_new() success: OK")
      return res # OK
    else
      log("direct_new() error: #{res.error!}")
      res.error!
    end
  end
  
end