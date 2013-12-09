require 'http_capture/version'

# Contains functionality to capture HTTP traffic from a variety of libraries.
module HttpCapture
  RESPONSES = []

  # Represents a captured request.
  class Request
    def initialize(real_request)
      @real_request = real_request
    end

    # The request method as an upper-case string.
    def method
      if @real_request.respond_to?(:request_method)
        @real_request.request_method.to_s.upcase
      else
        @real_request.method.to_s.upcase
      end
    end

    # The request path.
    def path
      @real_request.path
    end

    # The complete request URI.
    def uri
      uri = if @real_request.respond_to?(:uri)
              @real_request.uri
            else
              @real_request.url
            end
      uri = URI.parse(uri.to_s) unless uri.is_a?(URI)
      uri
    end
  end

  # Represents a captured response.
  class Response
    include Enumerable

    # The request that this is a response to.
    attr_reader :request

    # The duration of the request in seconds.
    attr_reader :duration

    def initialize(real_response, request: nil, duration: nil)
      @real_response = real_response
      @request = request
      @duration = duration
    end

    # Provides access to the response headers.
    def [](key)
      if @real_response.respond_to?(:[])
        @real_response[key]
      elsif @real_response.respond_to?(:headers)
        @real_response.headers[key]
      elsif @real_response.respond_to?(:header)
        @real_response.header[key]
      end
    end

    def each(&block)
      # some of the libraries return just header names in the each method; others return the header name and value
      # as an array. some downcase the header name but others leave them as they were. this adapts them to the most
      # useful and consistent which is an array of [name, value] with the name in lower case.
      action = Proc.new { |item| block.(item.is_a?(String) ? [item.downcase, self[item]] : item) }
      if @real_response.respond_to?(:each)
        @real_response.each &action
      elsif @real_response.respond_to?(:headers)
        @real_response.headers.each &action
      elsif @real_response.respond_to?(:header)
        @real_response.header.each &action
      end        
    end

    # The default status code accessor
    def status
      if @real_response.respond_to?(:code)
        @real_response.code.to_i
      else
        @real_response.status.to_i
      end
    end

    # The default body accessor
    def body
      @real_response.body
    end

    # Whether the request was successful.
    def successful?
      status >= 200 && status < 300
    end
  end
end