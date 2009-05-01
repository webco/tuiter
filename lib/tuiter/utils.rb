module Tuiter

  class Request
  
    # if :basic => options = {:username, :password}
    # if :oauth => options = {}
    def initialize(authentication_type, options)
      if [:basic, :oauth].include?(authentication_type)
        @authentication_type = authentication_type
      else
        raise StandardError, "Type of Authentication not informed (must be :basic or :oauth)."
      end
      @config = options
    end
  
    def request(http_method, path, *arguments)
      
    end
    
    def oauth_request(http_method, path, *arguments)
      
    end
    
    def basic_request(http_method, path, *arguments)
      if path !~ /^\//
        @http = create_http(path)
        _uri = URI.parse(path)
        path = "#{_uri.path}#{_uri.query ? "?#{_uri.query}" : ""}"
      end

      rsp = http.request(http_method, path, token, request_options, *arguments)
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