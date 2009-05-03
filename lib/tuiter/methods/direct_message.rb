# Direct Message Methods
# [X] direct_messages
# [ ] direct_messages/sent
# [X] direct_messages/new
# [ ] direct_messages/destroy

module Tuiter

  module DirectMessageMethods
    
    def direct_messages(options = {})
      url = '/direct_messages.json'
      params = parse_options(options) || ""

      if res = @request_handler.get(url+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::DirectMessage.new(d) }
      else
        return nil
      end
    end
    
    def direct_messages_sent(options = {})
      url = '/direct_messages/sent.json'
      params = parse_options(options) || ""

      if res = @request_handler.get(url+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::DirectMessage.new(d) }
      else
        return nil
      end
    end

    def direct_messages_new(user, text)
      log("direct_new() sending: #{text} to #{user}")      
      res = @request_handler.post('/direct_messages/new.json', {'user'=>user, 'text'=>text })
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

end

