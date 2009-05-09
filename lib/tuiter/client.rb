module Tuiter

  class Client
    include Tuiter::StatusMethods
    include Tuiter::UserMethods
    include Tuiter::DirectMessageMethods
    include Tuiter::FriendshipMethods
    include Tuiter::SocialGraphMethods
    include Tuiter::AccountMethods
   
    def initialize(options = {})
      @pid = Process.pid
      @logger = options[:logger] || Logger.new('tuiter.log')
      begin
        authentication_type = options.delete(:authentication)
        authentication_type = :basic if authentication_type.nil?
        @request_handler = Tuiter::Request.new(authentication_type, options)
      rescue
        return nil
      end
      log("initialize()")
    end
    
    def request_token
      @request_handler.request_token
    end
    
    def authorize(token, secret)
      @request_handler.authorize(token, secret)
    end

    def authorized?
      oauth_response = @request_handler.get('/account/verify_credentials.json')
      if oauth_response.class == Net::HTTPOK
        @username = JSON.parse(oauth_response.body)[:username]
        true
      else
        false
      end
    end

    def username
      @username ||= account_verify_credentials?.screen_name
    end

    private
    def parse_options(options)
      params = ""

      options.each do |k, v|
        unless params.empty?
          params = params + "&#{k}=#{v}"
        else  
          params = "?#{k}=#{v}"
        end
      end if (options && !options.empty?)

      return params
    end
    
    def log(message)
      @logger.info "[Tuiter:#{@pid}] #{Time.now.to_s} : #{message}"
    end
    
  end
  
end

