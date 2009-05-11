# Direct Message Methods
# [X] direct_messages
# [X] direct_messages/sent
# [X] direct_messages/new
# [X] direct_messages/destroy

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
      log("direct_messages_new() sending: #{text} to #{user}")      
      res = @request_handler.post('/direct_messages/new.json', {'user'=>user, 'text'=>text })

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("direct_messages_new() success: OK")
        return Tuiter::DirectMessage.new(JSON.parse(res.body))
      else
        log("direct_messages_new() error: #{res.error!}")
        res.error!
      end
    end
  
    def direct_messages_destroy(id)
      log("direct_messages_destroy(): #{id}")
      res = @request_handler.delete("/direct_messages/destroy/#{id}.json")

      case res
      when Net::HTTPSuccess
        log("direct_messages_destroy() #{id} success: OK")
        return Tuiter::DirectMessage.new(JSON.parse(res.body))
      else
        log("direct_messages_destroy() #{id} error: #{res.error!}")
        res.error!
      end
    end
  end

end

