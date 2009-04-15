module Tuiter

  require 'tuiter/methods/status'
  require 'tuiter/methods/user'
  require 'tuiter/methods/direct_message'
  require 'tuiter/methods/friendship'
  require 'tuiter/methods/social_graph'
  require 'tuiter/methods/account'

  class Client
    attr_accessor :username, :password
    
    def initialize(options = {})
      @pid = Process.pid
      @logger = options[:logger] || Logger.new('tuiter.log')
      @username = options[:username]
      @password = options[:password]
      @use_proxy = setup_a_proxy?
      log("initialize()")
    end

    include StatusMethods
    include UserMethods
    include DirectMessageMethods
    include FriendshipMethods
    include SocialGraphMethods
    include AccountMethods

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

