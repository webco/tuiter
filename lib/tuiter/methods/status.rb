# Status Methods
# [X] statuses/show
# [X] statuses/update
# [X] statuses/destroy

module Tuiter

  module StatusMethods
    
    def statuses_user(options = {})
      id  = options.delete(:id)
      id  = id.nil? ? "" : "/#{id}"
      url = "/statuses/user_timeline#{id}.json"
      params = parse_options(options) || ""

      if res = @request_handler.get(url+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::Status.new(d) }
      else
        return []
      end
    end
    
    def statuses_show(id)
      if res = @request_handler.get("/statuses/show/#{id}.json").body
        return Tuiter::Status.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def statuses_update(status, in_reply_to_status_id = nil)
      log("update() sending: #{status}")
      res = @request_handler.post('/statuses/update.json', {'status' => status, 'in_reply_to_status_id' => in_reply_to_status_id })
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("update() success: OK")
        return res # OK
      else
        log("update() error: #{res.to_s}")
        res.error!
      end
    end

    def statuses_destroy(id)
      if res = @request_handler.delete("/statuses/destroy/#{id}.json").body
        return Tuiter::Status.new(JSON.parse(res))
      else
        return nil
      end
    end
    
  end

end

