module Tuiter

  class Client
    include Tuiter::StatusMethods
    include Tuiter::UserMethods
    include Tuiter::DirectMessageMethods
    include Tuiter::FriendshipMethods
    include Tuiter::SocialGraphMethods
    include Tuiter::AccountMethods

    attr_accessor :username, :password
    
    def initialize(options = {})
      @pid = Process.pid
      @logger = options[:logger] || Logger.new('tuiter.log')
      begin
        authentication_type = options.delete(:authentication)
        @request_handler = Tuiter::Request.new(authentication_type, options)
      rescue
        return nil
      end
      log("initialize()")
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

