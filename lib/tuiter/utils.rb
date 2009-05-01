module Tuiter

  class Request
  
    # if :basic => options = {:username, :password}
    # if :oauth => options = {}
    # use proxy => {:proxy_host, :proxy_port, :proxy_user, :proxy_pass}
    def initialize(authentication_type, options)
      if [:basic, :oauth].include?(authentication_type)
        @authentication_type = authentication_type
      else
        raise StandardError, "Type of Authentication not informed (must be :basic or :oauth)."
      end
      @config = options
    end
    
    def request(http_method, path, *arguments)
      send(("#{@authentication_type.to_s}_request").to_sym, http_method, path, *arguments)
    end
    
    def get(path, headers = {})
      request(:get, path, headers)
    end
    
    def post(path, body = '' headers = {})
      request(:post, path, body, headers)
    end
    
    def put(path, body = '' headers = {})
      request(:post, path, body, headers)
    end
    
    def delete(path, headers = {})
      request(:delete, path, headers)
    end
    
    def head(path, headers = {})
      request(:head, path, headers)
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
    
    def oauth_request(http_method, path, *arguments)
      puts "ops, not implemented"
    end
    
    def basic_request(http_method, path, *arguments)
      if path !~ /^\//
        _uri = URI.parse(path)
        path = "#{_uri.path}#{_uri.query ? "?#{_uri.query}" : ""}"
      end

      response = http.request(basic_http_request(http_method, path, *arguments))
    end
    
    #Instantiates the http object
    def create_http
      tuiter_uri = URI.parse(TWITTER_API_BASE_URL)
      
      if (@config[:proxy_host] and @config[:proxy_port] and @config[:proxy_user] and @config[:proxy_pass])
        http_object = Net::HTTP.new(tuiter_uri.host, tuiter_uri.port, @proxy_host, @proxy_port, @proxy_user, @proxy_pass)
      else
        http_object = Net::HTTP.new(tuiter_uri.host, tuiter_uri.port)
      end

      http_object
    end
    
    #snippet from oauth gem
    def basic_http_request(http_method, path, *arguments)
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
      when :head
        request = Net::HTTP::Head.new(path,headers)
      else
        raise ArgumentError, "Don't know how to handle http_method: :#{http_method.to_s}"
      end
      
      # handling basic http auth
      req.basic_auth @config[:username], @config[:password]

      if data.is_a?(Hash)
        request.set_form_data(data)
      elsif data
        request.body = data.to_s
        request["Content-Length"] = request.body.length
      end

      request
    end
  end

end
