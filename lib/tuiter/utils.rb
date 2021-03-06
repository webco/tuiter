module Tuiter

  class Request
  
    # if :basic => options = {:username, :password}
    # if :oauth => options = {consumer_key, consumer_secret, token, secret}
    def initialize(authentication_type, options)
      if [:basic, :oauth].include?(authentication_type)
        @authentication_type = authentication_type
      else
        raise StandardError, "Type of Authentication not informed (must be :basic or :oauth)."
      end
      @config = options
    end
    
    def request_token
      oauth_consumer.get_request_token if @authentication_type == :oauth
    end
    
    def authorize(token, secret)
      if @authentication_type == :oauth
        request_token = OAuth::RequestToken.new(oauth_consumer, token, secret)
        @access_token = request_token.get_access_token
        @config[:token] = @access_token.token
        @config[:secret] = @access_token.secret
        @access_token
      end
    end
    
    def request(http_method, path, *arguments)
      send(("#{@authentication_type.to_s}_request").to_sym, http_method, path, *arguments)
    end
    
    def get(path, headers = {})
      request(:get, path, headers)
    end
    
    def post(path, body = '', headers = {})
      request(:post, path, body, headers)
    end
    
    def put(path, body = '', headers = {})
      request(:post, path, body, headers)
    end
    
    def delete(path, headers = {})
      request(:delete, path, headers)
    end
    
    def is_basic?
      return (@authentication_type == :basic)
    end
    
    def is_oauth?
      return (@authentication_type == :oauth)
    end
  
    private
      def http
        @http ||= create_http
      end
    
      def basic_request(http_method, path, *arguments)
        if path !~ /^\//
          _uri = URI.parse(path)
          _uri.path = "/" if _uri.path == ""
          path = "#{_uri.path}#{_uri.query ? "?#{_uri.query}" : ""}"
        end

        response = http.request(create_http_request(http_method, path, *arguments))
        return response        
      end
    
      #Instantiates the http object
      def create_http
        tuiter_uri = URI.parse(TWITTER_API_BASE_URL)
      
        http_proxy = ENV['http_proxy'] || ENV['HTTP_PROXY'] || nil
        if (http_proxy)
          proxy = URI.parse(http_proxy)
          if proxy.userinfo
            proxy_user, proxy_pass = proxy.userinfo.split(/:/) 
            http_object = Net::HTTP.new(tuiter_uri.host, tuiter_uri.port, proxy.host, proxy.port, proxy_user, proxy_pass)
          else
            http_object = Net::HTTP.new(tuiter_uri.host, tuiter_uri.port, proxy.host, proxy.port)
          end
        else
          http_object = Net::HTTP.new(tuiter_uri.host, tuiter_uri.port)
        end

        http_object
      end
    
      #snippet based on oauth gem
      def create_http_request(http_method, path, *arguments)
        http_method = http_method.to_sym

        if [:post, :put].include?(http_method)
          data = arguments.shift
        end

        headers = arguments.first.is_a?(Hash) ? arguments.shift : {}

        case http_method
        when :post
          request = Net::HTTP::Post.new(path,headers)
          request["Content-Length"] = 0 # Default to 0
        when :put
          request = Net::HTTP::Put.new(path,headers)
          request["Content-Length"] = 0 # Default to 0
        when :get
          request = Net::HTTP::Get.new(path,headers)
        when :delete
          request =  Net::HTTP::Delete.new(path,headers)
        else
          raise ArgumentError, "Don't know how to handle http_method: :#{http_method.to_s}"
        end
      
        # handling basic http auth
        request.basic_auth @config[:username], @config[:password]

        if data.is_a?(Hash)
          request.set_form_data(data)
        elsif data
          request.body = data.to_s
          request["Content-Length"] = request.body.length
        end

        request
      end
   
      def oauth_request(http_method, path, *arguments)
        oauth_response = oauth_access_token.request(http_method, path, *arguments)
        return oauth_response
      end
      
      def oauth_consumer
        @consumer ||= OAuth::Consumer.new(
          @config[:consumer_key],
          @config[:consumer_secret],
          { :site => TWITTER_API_BASE_URL }
        )
      end

      def oauth_access_token
        @access_token ||= OAuth::AccessToken.new(oauth_consumer, @config[:token], @config[:secret])
      end
  end

end
