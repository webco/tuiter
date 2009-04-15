module Tuiter

  require 'tuiter/methods/friendships'

  class Client
    attr_accessor :username, :password
    
    include FriendshipMethods
    
    def initialize(options = {})
      @pid = Process.pid
      @logger = options[:logger] || Logger.new('tuiter.log')
      @username = options[:username]
      @password = options[:password]
      @use_proxy = setup_a_proxy?
      log("initialize()")
    end
    
    def update(status, in_reply_to_status_id = nil)
      log("update() sending: #{status}")
      url = URI.parse('http://twitter.com/statuses/update.json')
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth @username, @password
      req.set_form_data({'status'=>status, 'in_reply_to_status_id'=>in_reply_to_status_id })
      res = new_http_for(url).start {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPReFion
        log("update() success: OK")
        return res # OK
      else
        log("update() error: #{res.to_s}")
        res.error!
      end
    end
    
    def direct_new(user, text)
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
   
    def direct_list(options = {})
      url = 'http://twitter.com/direct_messages.json'
      params = parse_options(options) || ""

      if res = request(url+params)
        data = JSON.parse(res)
        return data.map { |d| DirectMessage.new(d) }
      else
        return nil
      end
    end

    def verify_credentials?
      if res = request("http://twitter.com/account/verify_credentials.json")
        return UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def get_followers(options = {})
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
      if res = request(query+params)
        data = JSON.parse(res)
        return data.map { |d| User.new(d) }
      else
        return nil
      end
    end
 
    def get_followers_ids 
      if res = request("http://twitter.com/followers/ids/#{username}.json")
        return JSON.parse(res)
      else
        return nil
      end
    end
   
    def get_friends(options = {})
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
      if res = request(query+params)
        data = JSON.parse(res)
        return data.map { |d| User.new(d) }
      else
        return nil
      end
    end

    def get_replies(options = {})
      query = "http://twitter.com/statuses/replies.json"
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
        return data.map { |d| Status.new(d) }
      else
        return nil
      end
    end
    
    def get_client
      if res = request("http://twitter.com/users/show/#{@username}.json")
        return UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def get_user(id)
      if res = request("http://twitter.com/users/show/#{id}.json")
        return UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def get_status(id)
      if res = request("http://twitter.com/statuses/show/#{id}.json")
        return Status.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def rate_limit
      if res = request("http://twitter.com/account/rate_limit_status.json")
        return RateLimit.new(JSON.parse(res))
      else
        return nil
      end
    end
  
    private

    def request(url)
      http = nil
      status = Timeout::timeout(10) do
        log("request() query: #{url}")
        http = open(url, :http_basic_authentication=>[@username, @password])
        log("request() debug: http status is #{http.status.join(' ')}")
        if http.status == ["200", "OK"]
          res = http.read
          return res
        end
        return nil        
      end
    rescue Timeout::Error
      log("request() error: timeout error")
      return nil
    rescue OpenURI::HTTPError => e
      log("request() http error: #{e.message} in #{e.backtrace.first.to_s}")
      return nil
    rescue Exception => e
      log("request() error: #{e.message} in #{e.backtrace.first.to_s}")
      return nil
    end
   
    def parse_options(options)
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

      return params
    end

    def setup_a_proxy?
      http_proxy = ENV['http_proxy'] || ENV['HTTP_PROXY'] || nil
      
      if http_proxy
        proxy = URI.parse(http_proxy)

        @proxy_host = proxy.host
        @proxy_port = proxy.port
        @proxy_user, @proxy_pass = proxy.userinfo.split(/:/) if proxy.userinfo
      end
    
      http_proxy != nil
    end
    
    def new_http_for(url)
      if @use_proxy
        http = Net::HTTP.new(url.host, url.port, @proxy_host, @proxy_port, @proxy_user, @proxy_pass)
      else
        http = Net::HTTP.new(url.host, url.port)
      end
    end

    def log(message)
      @logger.info "[Tuiter:#{@pid}] #{Time.now.to_s} : #{message}"
    end
    
  end
  
end

