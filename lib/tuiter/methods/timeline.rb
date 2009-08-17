# Timeline Methods
# [ ] statuses/public_timeline
# [ ] statuses/friends_timeline
# [X] statuses/user_timeline
# [X] statuses/mentions

module Tuiter

  module TimelineMethods

    def statuses_user_timeline(id = nil, options = {})
      if id.kind_of? Hash
        options.merge(id)
        id = username
      end

      options.delete(:user_id) if options.has_key? :screen_name
      id ||= username
      
      unless (options[:screen_name] || options[:user_id])
        url = "/statuses/user_timeline/#{id}.json"
      else
        url = "/statuses/user_timeline.json"
      end
      
      params = parse_options(options) || ""
      res = @request_handler.get(url+params)

      if res
        data = JSON.parse(res.body)
        return data.map { |d| Tuiter::Status.new(d) }
      else
        res.error!
      end
    end

    def statuses_mentions(options = {})
      url = "/statuses/mentions.json"
      params = parse_options(options)

      if res = @request_handler.get(url+params).body
        data = JSON.parse(res)
        return data.map { |d| Tuiter::Status.new(d) }
      else
        return nil
      end
    end

  end

end

