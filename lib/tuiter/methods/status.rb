# Status Methods
# [ ] statuses/public_timeline
# [ ] statuses/friends_timeline
# [ ] statuses/user_timeline
# [X] statuses/show
# [X] statuses/update
# [X] statuses/mentions
# [ ] statuses/destroy

module Tuiter

  module StatusMethods
    
    def statuses_show(id)
      if res = request("http://twitter.com/statuses/show/#{id}.json")
        return Tuiter::Status.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def statuses_update(status, in_reply_to_status_id = nil)
      log("update() sending: #{status}")
      url = URI.parse('http://twitter.com/statuses/update.json')
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth @username, @password
      req.set_form_data({'status'=>status, 'in_reply_to_status_id'=>in_reply_to_status_id })
      res = new_http_for(url).start {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("update() success: OK")
        return res # OK
      else
        log("update() error: #{res.to_s}")
        res.error!
      end
    end
    
    def statuses_mentions(options = {})
      query = "http://twitter.com/statuses/mentions.json"
      if options[:since]
        params = "?since=#{options[:since]}"
      elsif options[:since_id]
        params = "?since_id=#{options[:since_id]}"
      else
        params = ""
      end
      if options[:page]
        if params == ""
            params = "?page=#{options[:page]}"
        else
            params = params + "&" + "page=#{options[:page]}"
        end
      end
      if res = request(query+params)
        data = JSON.parse(res)
        return data.map { |d| Tuiter::Status.new(d) }
      else
        return nil
      end
    end
    
  end

end

