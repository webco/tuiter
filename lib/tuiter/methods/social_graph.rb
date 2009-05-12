# Social Graph Methods
# [X] friends/ids
# [X] followers/ids

module Tuiter

  module SocialGraphMethods
    
    def followers_ids(options = {})
      options.delete(:user_id) if options.has_key? :screen_name

      unless (options[:screen_name] || options[:user_id])
        url = "/followers/ids/#{username}.json"
      else
        url = "/followers/ids.json"
      end

      params = parse_options(options) || ""
      res = @request_handler.get(url+params)

      case res
      when Net::HTTPSuccess
        return JSON.parse(res.body)
      else
        return nil
      end
    end

    def followers_ids(options = {})
      options.delete(:user_id) if options.has_key? :screen_name

      unless (options[:screen_name] || options[:user_id])
        url = "/friends/ids/#{username}.json"
      else
        url = "/friends/ids.json"
      end

      params = parse_options(options) || ""
      res = @request_handler.get(url+params)

      case res
      when Net::HTTPSuccess
        return JSON.parse(res.body)
      else
        return nil
      end
    end

  end

end

