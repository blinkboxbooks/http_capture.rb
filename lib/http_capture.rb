require 'http_capture/version'

module HttpCapture
  RESPONSES = []

  class Response
    include Enumerable

    def initialize(real_response)
      @real_response = real_response
    end

    # The default header accessor
    def [](key)
      @real_response[key]
    end

    def each(&block)
      if @real_response.respond_to?(:header)
        @real_response.header.each(&block)
      elsif @real_response.respond_to?(:headers)
        @real_response.headers.each(&block)
      else
        @real_response.each(&block)
      end
    end

    # The default status code accessor
    def status
      @real_response.status
    end

    # The default body accessor
    def body
      @real_response.body
    end
  end

  class MockResponse
    include Enumerable

    attr_accessor :status
    attr_accessor :body

    def initialize
      @header = {}
    end

    # The default header accessor
    def [](key)
      @header[key]
    end

    # The default header accessor
    def []=(key, value)
      @header[key] = value
    end

    def each(&block)
      @header.each(&block)
    end
  end
end