require 'open-uri'
require 'uri'
require 'net/http'
require 'json'
require 'logger'

module Tuiter

  # TUITER_CONFIG = YAML::load(File.open("#{RAILS_ROOT}/config/tuiter.yml"))[RAILS_ENV]
  
  class Client
    attr_accessor :username, :password
    
    def initialize(options = {})
      @pid = Process.pid
      @logger = options[:logger] || Logger.new('tuiter.log') #Logger.new("#{RAILS_ROOT}/log/tuiter.log")
      @username = options[:username] # || TUITER_CONFIG['username']
      @password = options[:password] # || TUITER_CONFIG['password']
      log("initialize()")
    end
    
    def update(status, in_reply_to_status_id = nil)
      log("update() sending: #{status}")
      url = URI.parse('http://twitter.com/statuses/update.json')
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth @username, @password
      req.set_form_data({'status'=>status, 'in_reply_to_status_id'=>in_reply_to_status_id })
      res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("update() success: OK")
        return res # OK
      else
        log("update() error: #{res.error!}")
        res.error!
      end
    end
    
    def direct_new(user, text)
      log("direct_new() sending: #{text} to #{user}")
      url = URI.parse('http://twitter.com/direct_messages/new.json')
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth @username, @password
      req.set_form_data({'user'=>user, 'text'=>text })
      res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("direct_new() success: OK")
        return res # OK
      else
        log("direct_new() error: #{res.error!}")
        res.error!
      end
    end
    
    def friendship_new(user, follow = nil)
      log("friendship_new() following: #{user}")
      url = URI.parse("http://twitter.com/friendships/create/#{user}.json")
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth @username, @password
      req.set_form_data({'follow'=>"true"}) if follow
      res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("friendship_new() success: OK")
        return res # OK
      else
        log("friendship_new() error: #{res.error!}")
        res.error!
      end
    end
    
    def verify_credentials?
      if res = request("http://twitter.com/account/verify_credentials.json")
        return Tuiter::UserExtended.new(JSON.parse(res))
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
        return data.map { |d| Tuiter::Status.new(d) }
      else
        return nil
      end
    end
    
    def get_client
      if res = request("http://twitter.com/users/show/#{@username}.json")
        return Tuiter::UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def get_user(id)
      if res = request("http://twitter.com/users/show/#{id}.json")
        return Tuiter::UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def get_status(id)
      if res = request("http://twitter.com/statuses/show/#{id}.json")
        return Tuiter::Status.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def rate_limit
      if res = request("http://twitter.com/account/rate_limit_status.json")
        return Tuiter::RateLimit.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def follows_me?(id)
      if res = request("http://twitter.com/friendships/exists.json?user_a=#{id}&user_b=#{@username}")
        return true if res == "true"
        return false
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

    def log(message)
      @logger.info "[Tuiter:#{@pid}] #{Time.now.to_s} : #{message}"
    end
    
  end
  
end

